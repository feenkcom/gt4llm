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

{ #category : #accessing }
GtLACPClaudeCodeSessionStore >> issues [
	^ super issues , (sessions values flatCollect: #issues)
]

{ #category : #clients }
GtLACPClaudeCodeSessionStore >> newClient [
	^ GtLACPClaudeCodeClient new
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
	(self sessionAt: aFile basenameWithoutExtension) file: aFile
]

{ #category : #private }
GtLACPClaudeCodeSessionStore >> storedSessionClass [
	^ GtLACPClaudeCodeStoredSession
]
