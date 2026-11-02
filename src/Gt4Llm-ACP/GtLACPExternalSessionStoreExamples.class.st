"
Executable filesystem fixtures and inspector checks for discovering native Codex and Claude Code sessions without installed agents or external runtimes.
"
Class {
	#name : #GtLACPExternalSessionStoreExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> allDiscoveryViews [
 <gtExample>
 | codex claude query objects |
 codex := self codexStore.
 claude := self claudeStore.
 query := codex forDirectory: self projectDirectory.
 objects := { codex. claude. query. codex sessions first.
  self codexSourceMetadata. codex issues first }.
 objects do: [ :object |
  object class allMethods do: [ :method |
   ((method pragmaAt: #gtView) notNil and: [ method methodClass package name = 'Gt4Llm-ACP' ])
    ifTrue: [ | result |
     result := GtPhlowViewTester new testView: (object perform: method selector with: GtPhlowView empty).
     self assert: (result isOk or: [ result isEmpty ]) description: object class name, '>>', method selector ] ] ].
 ^ query
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> claudeProjectQuery [
 <gtExample>
 | query |
 query := self claudeStore forDirectory: self projectDirectory.
 self assert: query sessions size equals: 1.
 self assert: query sessions first sessionId equals: self firstId.
 self assert: query unresolvedSessions isEmpty.
 ^ query
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> claudeQueryInspector [
 <gtExample>
 | query scripter |
 query := self claudeProjectQuery.
 scripter := BlScripter new extent: 1200 @ 650; model: query;
  element: (GtInspector forObject: query); yourself.
 scripter assertStep: [ :step | step onPhlowCellWithString: self firstId; exists ].
 scripter assertStep: [ :step |
  step onPhlowCellWithString: query sessions first createdAt asString; exists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> claudeRoot [
 | root |
 root := FileSystem memory root / 'claude'.
 root ensureCreateDirectory.
 self writeRecords: {
  { 'type' -> 'queue-operation'. 'sessionId' -> self firstId } asDictionary.
  { 'type' -> 'user'. 'sessionId' -> self firstId. 'cwd' -> self projectDirectory fullName.
   'timestamp' -> '2026-10-30T13:00:00Z'. 'slug' -> 'Readme check'.
   'message' -> { 'content' -> 'Conversation body is not retained' } asDictionary } asDictionary
 } to: root / 'projects' / 'lossy-encoded-name' / (self firstId, '.jsonl').
 self writeRecords: {
  { 'type' -> 'user'. 'sessionId' -> self secondId.
   'cwd' -> (self projectDirectory fullName, '-other').
   'timestamp' -> '2026-10-29T13:00:00Z' } asDictionary
 } to: root / 'projects' / 'another-name' / (self secondId, '.jsonl').
 self writeRecords: {
  { 'sessionId' -> 'subagent'. 'cwd' -> self projectDirectory fullName } asDictionary
 } to: root / 'projects' / 'lossy-encoded-name' / self firstId / 'subagents' / 'agent-sub.jsonl'.
 self writeRecords: {
  { 'sessionId' -> 'orphan'. 'cwd' -> self projectDirectory fullName } asDictionary
 } to: root / 'projects' / 'lossy-encoded-name' / 'old.orphaned-123-example.jsonl'.
 ^ root
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> claudeSourceMetadata [
 <gtExample>
 | source |
 source := self claudeProjectQuery sessions first sources first.
 self assert: (source metadata at: 'cwd') equals: self projectDirectory fullName.
 self assert: (source metadata at: 'sessionId') equals: self firstId.
 self assert: (source metadata includesKey: 'message') not.
 ^ source
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> claudeStore [
 <gtExample>
 | store session |
 store := (GtLACPClaudeCodeSessionStore on: self claudeRoot) read.
 self assert: store sessions size equals: 2.
 self assert: store issues isEmpty.
 session := store sessions detect: [ :each | each sessionId = self firstId ].
 self assert: session directory equals: self projectDirectory.
 self assert: session title equals: 'Readme check'.
 self assert: (session sources first metadata includesKey: 'message') not.
 ^ store
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> codexProjectQuery [
 <gtExample>
 | query |
 query := self codexStore forDirectory: self projectDirectory.
 self assert: query sessions size equals: 1.
 self assert: query sessions first sessionId equals: self firstId.
 self assert: query unresolvedSessions size equals: 2.
 ^ query
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> codexRoot [
 | root |
 root := FileSystem memory root / 'codex'.
 root ensureCreateDirectory.
 self writeRecords: {
  { 'id' -> self firstId. 'thread_name' -> 'Current title'. 'updated_at' -> '2026-10-30T14:00:00Z' } asDictionary.
  { 'id' -> self firstId. 'thread_name' -> 'Older title'. 'updated_at' -> '2026-10-29T14:00:00Z' } asDictionary.
  { 'id' -> self secondId. 'thread_name' -> 'Index only'. 'updated_at' -> '2026-10-30T12:00:00Z' } asDictionary
 } to: root / 'session_index.jsonl'.
 self writeRecords: {
  { 'type' -> 'session_meta'. 'payload' -> {
   'id' -> self firstId. 'cwd' -> self projectDirectory fullName.
   'timestamp' -> '2026-10-30T13:00:00Z'. 'cli_version' -> 'example'.
   'instructions' -> 'Not discovery metadata' } asDictionary } asDictionary.
  { 'type' -> 'response_item'. 'payload' -> { 'content' -> 'Conversation body is not retained' } asDictionary } asDictionary
 } to: root / 'sessions' / '2026' / '10' / '30' / ('rollout-example-', self firstId, '.jsonl').
 self writeRecords: {
  { 'type' -> 'session_meta'. 'payload' -> {
   'id' -> 'other-project'. 'cwd' -> (self projectDirectory fullName, '-other').
   'timestamp' -> '2026-10-30T11:00:00Z' } asDictionary } asDictionary
 } to: root / 'archived_sessions' / 'rollout-other.jsonl'.
 (root / 'sessions' / '2026' / '10' / '30' / ('rollout-2026-10-30T13-00-00-', self compressedId, '.jsonl.zst'))
  writeStreamDo: [ :stream | stream nextPutAll: 'Not decoded by the metadata reader' ].
 (root / 'state_5.sqlite') writeStreamDo: [ :stream | stream nextPutAll: 'Not opened by the metadata reader' ].
 ^ root
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> codexSourceMetadata [
 <gtExample>
 | source |
 source := (self codexProjectQuery sessions first sources detect: [ :each | each format = #codexRollout ]).
 self assert: (source metadata at: 'cwd') equals: self projectDirectory fullName.
 self assert: (source metadata includesKey: 'instructions') not.
 self assert: (source metadata includesKey: 'content') not.
 ^ source
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> codexStore [
 <gtExample>
 | store session |
 store := (GtLACPCodexSessionStore on: self codexRoot) read.
 self assert: store sessions size equals: 4.
 session := store sessions detect: [ :each | each sessionId = self firstId ].
 self assert: session title equals: 'Current title'.
 self assert: session directory equals: self projectDirectory.
 self assert: session sources size equals: 3.
 self assert: session createdAt notNil.
 self assert: session updatedAt notNil.
 self assert: store issues size equals: 2.
 ^ store
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> compressedId [
 ^ '33333333-3333-4333-8333-333333333333'
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> compressedSessionIdentity [
 <gtExample>
 | session |
 session := self codexStore sessions detect: [ :each | each sessionId = self compressedId ].
 self assert: session directory isNil.
 self assert: session sources first format equals: #codexCompressedRollout.
 self assert: (session sources first metadata at: 'filenameSessionId') equals: self compressedId.
 ^ session
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> conflictingDirectoryIsReported [
 <gtExample>
 | root file store |
 root := self codexRoot.
 file := root / 'sessions' / 'rollout-conflicting.jsonl'.
 self writeRecords: { {
  'type' -> 'session_meta'. 'payload' -> {
   'id' -> self firstId. 'cwd' -> (self projectDirectory fullName, '-conflict') } asDictionary } asDictionary } to: file.
 store := (GtLACPCodexSessionStore on: root) read.
 self assert: (store issues anySatisfy: [ :issue |
  issue description includesSubstring: 'Conflicting project directory' ]).
 ^ store
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> filenameIdentityConflictIsReported [
 <gtExample>
 | root file store |
 root := self claudeRoot.
 file := root / 'projects' / 'conflict' / 'wrong-id.jsonl'.
 self writeRecords: { {
  'sessionId' -> self secondId. 'cwd' -> self projectDirectory fullName } asDictionary } to: file.
 store := (GtLACPClaudeCodeSessionStore on: root) read.
 self assert: (store sessions detect: [ :session | session sessionId = 'wrong-id' ]) directory isNil.
 self assert: (store issues anySatisfy: [ :issue |
  issue description includesSubstring: 'Session ID disagrees' ]).
 ^ store
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> firstId [
 ^ '11111111-1111-4111-8111-111111111111'
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> malformedRecordIsReported [
 <gtExample>
 | root file store |
 root := self codexRoot.
 file := root / 'sessions' / 'rollout-partial.jsonl'.
 file writeStreamDo: [ :stream |
  stream nextPutAll: '{broken JSON'; lf.
  stream nextPutAll: (STONJSON toString: {
   'type' -> 'session_meta'. 'payload' -> {
    'id' -> 'recovered'. 'cwd' -> self projectDirectory fullName.
    'timestamp' -> '2026-10-30T15:00:00Z' } asDictionary } asDictionary); lf ].
 store := (GtLACPCodexSessionStore on: root) read.
 self assert: (store sessions anySatisfy: [ :each | each sessionId = 'recovered' ]).
 self assert: (store issues anySatisfy: [ :issue | issue file = file and: [ issue lineNumber = 1 ] ]).
 ^ store
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> metadataPrefixIsBounded [
 <gtExample>
 | root file store records |
 root := FileSystem memory root / 'claude'.
 file := root / 'projects' / 'encoded' / (self firstId, '.jsonl').
 records := ((1 to: 50) collect: [ :index |
  { 'type' -> 'queue-operation'. 'sessionId' -> self firstId } asDictionary ]) asOrderedCollection.
 records add: { 'sessionId' -> self firstId. 'cwd' -> self projectDirectory fullName } asDictionary.
 self writeRecords: records to: file.
 store := (GtLACPClaudeCodeSessionStore on: root) read.
 self assert: store sessions first directory isNil.
 self assert: store issues notEmpty.
 ^ store
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> missingStorage [
 <gtExample>
 | root codex claude |
 root := FileSystem memory root / 'absent'.
 codex := (GtLACPCodexSessionStore on: root) read.
 claude := (GtLACPClaudeCodeSessionStore on: root) read.
 self assert: codex sessions isEmpty.
 self assert: claude sessions isEmpty.
 self assert: codex issues size equals: 1.
 self assert: claude issues size equals: 1.
 ^ codex
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> projectDirectory [
 ^ (FileLocator temp / 'gt-acp-query-example-project') asFileReference asAbsolute
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> projectQueryInspector [
 <gtExample>
 | query scripter |
 query := self codexProjectQuery.
 scripter := BlScripter new extent: 1200 @ 650; model: query;
  element: (GtInspector forObject: query); yourself.
 scripter assertStep: [ :step | step onPhlowCellWithString: self firstId; exists ].
 scripter clickStep: [ :step |
  step onChildFromBlock: [ :root | self tabNamed: 'Unknown directory' in: root ] ].
 scripter assertStep: [ :step | step onPhlowCellWithString: self compressedId; exists ].
 scripter clickStep: [ :step |
  step onChildFromBlock: [ :root | self tabNamed: 'Read problems' in: root ] ].
 scripter assertStep: [ :step |
  step onPhlowCellWithString: 'Compressed rollout: identity read from filename; metadata not decoded'; exists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> readingDoesNotChangeArtifacts [
 <gtExample>
 | root before after store |
 root := self codexRoot.
 before := (root allChildren select: #isFile) collect: [ :file | file -> file contents ].
 store := (GtLACPCodexSessionStore on: root) read.
 store read.
 after := (root allChildren select: #isFile) collect: [ :file | file -> file contents ].
 self assert: after equals: before.
 self assert: store sessions size equals: 4.
 ^ store
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> reloadCompletesPartialTranscript [
 <gtExample>
 | root file store query |
 root := FileSystem memory root / 'claude'.
 file := root / 'projects' / 'encoded' / (self firstId, '.jsonl').
 file parent ensureCreateDirectory.
 file writeStreamDo: [ :stream | stream nextPutAll: '{"sessionId":' ].
 store := (GtLACPClaudeCodeSessionStore on: root) read.
 query := store forDirectory: self projectDirectory.
 self assert: query sessions isEmpty.
 self assert: query unresolvedSessions size equals: 1.
 self assert: store issues notEmpty.
 self writeRecords: { {
  'sessionId' -> self firstId. 'cwd' -> self projectDirectory fullName.
  'timestamp' -> '2026-10-30T13:00:00Z' } asDictionary } to: file.
 store read.
 self assert: query sessions size equals: 1.
 self assert: query unresolvedSessions isEmpty.
 self assert: store issues isEmpty.
 ^ query
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> secondId [
 ^ '22222222-2222-4222-8222-222222222222'
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> tabNamed: aString in: anElement [
 | found |
 anElement withAllChildrenBreadthFirstDo: [ :each |
  ((each isKindOf: BrTab) and: [ each label asString = aString ])
   ifTrue: [ found ifNil: [ found := each ] ] ].
 ^ found ifNil: [ self error: 'Tab not found: ', aString ]
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> writeRecords: records to: aFile [
 aFile parent ensureCreateDirectory.
 aFile writeStreamDo: [ :stream |
  records do: [ :record | stream nextPutAll: (STONJSON toString: record); lf ] ]
]
