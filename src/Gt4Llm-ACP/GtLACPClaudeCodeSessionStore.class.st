"
I read Claude Code project transcript metadata. The transcript filename identifies the session, while its recorded cwd identifies the project. I do not infer project paths by reversing the lossy encoded folder name.
"
Class {
	#name : #GtLACPClaudeCodeSessionStore,
	#superclass : #GtLACPExternalSessionStore,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPClaudeCodeSessionStore >> agentName [
 ^ 'Claude Code'
]

{ #category : #defaults }
GtLACPClaudeCodeSessionStore >> defaultDirectory [
 | configured |
 configured := OSEnvironment current at: 'CLAUDE_CONFIG_DIR' ifAbsent: [ nil ].
 ^ configured isEmptyOrNil
  ifTrue: [ (FileLocator home / '.claude') asFileReference ]
  ifFalse: [ configured asFileReference ]
]

{ #category : #reading }
GtLACPClaudeCodeSessionStore >> readSessions [
 | projects |
 projects := rootDirectory / 'projects'.
 projects isDirectory ifFalse: [ ^ self ].
 projects directories do: [ :project |
  project files do: [ :file |
   ((file basename endsWith: '.jsonl') and: [
    (file basename includesSubstring: '.orphaned-') not and: [
     (file basename includesSubstring: '.superseded-') not ] ])
    ifTrue: [ self readTranscript: file ] ] ]
]

{ #category : #reading }
GtLACPClaudeCodeSessionStore >> readTranscript: aFile [
 | identifier session metadata found |
 identifier := aFile basename allButLast: '.jsonl' size.
 session := self sessionAt: identifier.
 metadata := { 'filenameSessionId' -> identifier } asDictionary.
 found := false.
 self readJsonLines: aFile limit: 50 do: [ :record :line |
  (record includesKey: 'cwd')
   ifFalse: [ false ]
   ifTrue: [
    | nativeId |
    metadata addAll: (self metadataFrom: record keys:
     #('sessionId' 'cwd' 'timestamp' 'slug' 'gitBranch' 'version')).
    nativeId := record at: 'sessionId' ifAbsent: [ identifier ].
    nativeId = identifier
     ifFalse: [
      self issueFor: aFile line: line description: 'Session ID disagrees with transcript filename'.
      true ]
     ifTrue: [
      self directory: (record at: 'cwd') for: session file: aFile line: line.
      session createdAt: (self dateFrom: (record at: 'timestamp' ifAbsent: [ nil ]) file: aFile line: line).
      session title: (record at: 'slug' ifAbsent: [ '' ]).
      found := true.
      true ] ] ].
 session addSource: (self sourceFile: aFile format: #claudeTranscript metadata: metadata).
 found ifFalse: [
  self issueFor: aFile line: nil description: 'Project directory is unknown after scanning up to 50 records' ]
]
