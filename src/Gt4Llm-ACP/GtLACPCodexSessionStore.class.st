"
I read Codex session_index.jsonl and rollout metadata from sessions and archived_sessions. Compressed rollouts retain their filename identity and an explicit coverage issue; no external decompressor or SQLite dependency is required.
"
Class {
	#name : #GtLACPCodexSessionStore,
	#superclass : #GtLACPExternalSessionStore,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPCodexSessionStore >> agentName [
 ^ 'Codex'
]

{ #category : #defaults }
GtLACPCodexSessionStore >> defaultDirectory [
 | configured |
 configured := OSEnvironment current at: 'CODEX_HOME' ifAbsent: [ nil ].
 ^ configured isEmptyOrNil
  ifTrue: [ (FileLocator home / '.codex') asFileReference ]
  ifFalse: [ configured asFileReference ]
]

{ #category : #reading }
GtLACPCodexSessionStore >> readCompressedRollout: aFile [
 | basename identifier session |
 [ basename := aFile basename allButLast: '.jsonl.zst' size.
 identifier := basename last: 36.
 UUID fromString: identifier.
 session := self sessionAt: identifier.
 session addSource: (self sourceFile: aFile format: #codexCompressedRollout
  metadata: { 'filenameSessionId' -> identifier } asDictionary).
 self issueFor: aFile line: nil description: 'Compressed rollout: identity read from filename; metadata not decoded' ]
  on: Error do: [ :error | self issueFor: aFile line: nil description: error messageText ]
]

{ #category : #reading }
GtLACPCodexSessionStore >> readIndex: aFile [
 self readJsonLines: aFile limit: Float infinity do: [ :record :line |
  | session source updated |
  session := self sessionAt: (record at: 'id').
  source := self sourceFile: aFile format: #codexIndex metadata:
   (self metadataFrom: record keys: #('id' 'thread_name' 'name' 'updated_at')).
  session addSource: source.
  updated := self dateFrom: (record at: 'updated_at' ifAbsent: [ nil ]) file: aFile line: line.
  (session updatedAt isNil or: [ updated notNil and: [ updated >= session updatedAt ] ]) ifTrue: [
   session title: (record at: 'thread_name' ifAbsent: [ record at: 'name' ifAbsent: [ '' ] ]).
   updated ifNotNil: [ session updatedAt: updated ] ].
  false ]
]

{ #category : #reading }
GtLACPCodexSessionStore >> readRollout: aFile [
 | found |
 found := false.
 self readJsonLines: aFile limit: 50 do: [ :record :line |
  (record at: 'type' ifAbsent: [ '' ]) = 'session_meta'
   ifFalse: [ false ]
   ifTrue: [
    | metadata session created |
    metadata := record at: 'payload'.
    session := self sessionAt: (metadata at: 'id').
    session addSource: (self sourceFile: aFile format: #codexRollout metadata:
     (self metadataFrom: metadata keys: #('id' 'cwd' 'timestamp' 'originator' 'cli_version'))).
    metadata at: 'cwd' ifPresent: [ :project | self directory: project for: session file: aFile line: line ].
    created := self dateFrom: (metadata at: 'timestamp' ifAbsent: [ nil ]) file: aFile line: line.
    created ifNotNil: [ session createdAt: created ].
    found := true.
    true ] ].
 found ifFalse: [
  self issueFor: aFile line: nil description: 'No session_meta record found in the first 50 records' ]
]

{ #category : #reading }
GtLACPCodexSessionStore >> readSessions [
 | index |
 index := rootDirectory / 'session_index.jsonl'.
 index isFile ifTrue: [ self readIndex: index ].
 #('sessions' 'archived_sessions') do: [ :name |
  | directory |
  directory := rootDirectory / name.
  directory isDirectory ifTrue: [
   directory allChildren do: [ :file |
    file isFile ifTrue: [
     (file basename beginsWith: 'rollout-') ifTrue: [
      (file basename endsWith: '.jsonl') ifTrue: [ self readRollout: file ].
      (file basename endsWith: '.jsonl.zst') ifTrue: [ self readCompressedRollout: file ] ] ] ] ] ].
 rootDirectory children do: [ :file |
  ((file basename beginsWith: 'state_') and: [ file basename endsWith: '.sqlite' ]) ifTrue: [
   self issueFor: file line: nil
    description: 'SQLite index not read; discovery uses rollout files and session_index.jsonl' ] ]
]
