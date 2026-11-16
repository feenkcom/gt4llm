"
Executable filesystem fixtures and inspector checks for discovering native Codex and Claude Code sessions without installed agents or external runtimes.
"
Class {
	#name : #GtLACPExternalSessionStoreExamples,
	#superclass : #GtLACPStoredSessionFixtures,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> allDiscoveryViews [
	<gtExample>
	| codex claude query objects |
	codex := self codexStore.
	claude := self claudeStore.
	query := codex forDirectory: self projectDirectory.
	objects := {codex.
			claude.
			query.
			codex sessions first.
			codex sessions first sources first.
			codex issues first}.
	self assertViewsFor: objects.
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
	self assert: store newClient class equals: GtLACPClaudeCodeClient.
	self assert: session class equals: GtLACPClaudeCodeStoredSession.
	self assert: store allSessions equals: store sessions.
	^ store
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> codexHeaderStopsBeforeConversation [
	<gtExample>
	| root file store |
	root := FileSystem memory root / 'codex'.
	file := root / 'sessions' / ('rollout-example-' , self firstId , '.jsonl').
	file parent ensureCreateDirectory.
	file
		binaryWriteStreamDo: [ :stream | 
			stream
				nextPutAll: (STONJSON
						toString: {'type' -> 'session_meta'.
								'payload'
									-> {'id' -> self firstId.
											'cwd' -> (self projectDirectory / 'Révision 🦊') fullName.
											'timestamp' -> '2026-11-01T10:00:00Z'} asDictionary} asDictionary)
						utf8Encoded;
				nextPut: 10;
				nextPutAll: #[255 254 123 98 114 111 107 101 110] ].
	store := (GtLACPCodexSessionStore on: root) read.
	self assert: store issues isEmpty.
	self
		assert: (store sessionWithId: self firstId) directory
		equals: self projectDirectory / 'Révision 🦊'.
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
	self assert: store newClient class equals: GtLACPCodexClient.
	self assert: session class equals: GtLACPCodexStoredSession.
	^ store
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> conditionalSessionLookup [
	<gtExample>
	| stores |
	stores := {self claudeStore.
			self codexStore}.
	stores
		do: [ :store | 
			| count present absent result |
			count := store sessions size.
			present := 0.
			absent := 0.
			result := store
					sessionWithId: self firstId
					ifPresent: [ :session | 
						present := present + 1.
						self assert: session == (store sessionWithId: self firstId).
						nil ]
					ifAbsent: [ absent := absent + 1.
						#missing ].
			self assert: result isNil.
			self assert: present equals: 1.
			self assert: absent equals: 0.
			result := store
					sessionWithId: 'missing'
					ifPresent: [ :session | present := present + 1 ]
					ifAbsent: [ absent := absent + 1.
						#missing ].
			self assert: result equals: #missing.
			self assert: present equals: 1.
			self assert: absent equals: 1.
			self assert: store sessions size equals: count ].
	^ stores
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

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> invalidStoredSessionsCannotLoad [
	<gtExample>
	| stores |
	stores := {self claudeStore.
			self codexStore}.
	stores
		do: [ :store | 
			| stored |
			stored := store sessionWithId: self firstId.
			self directory: nil forStoredSession: stored.
			self
				assert: ([ stored load.
					false ]
						on: Error
						do: [ :error | error messageText includesSubstring: 'directory is unknown' ]).
			self directory: FileSystem memory root / 'missing' forStoredSession: stored.
			self
				assert: ([ stored load.
					false ]
						on: Error
						do: [ :error | error messageText includesSubstring: 'directory no longer exists' ]) ].
	^ stores
]

{ #category : #fixtures }
GtLACPExternalSessionStoreExamples >> loadableStoredSession [
	| store stored client |
	store := self codexStore.
	stored := store sessionWithId: self firstId.
	client := stored newClient.
	client
		transportFactory: [ :configuration :directory | GtLACPExamples new transport ].
	^ GtLACPFixtureStoredSession new
		store: store;
		sessionId: stored sessionId;
		title: stored title;
		directory: FileLocator temp asFileReference asAbsolute;
		client: client;
		yourself
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

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> storedSessionLoadActionOpensChat [
	<gtExample>
	| stored pager scripter tool deadline |
	stored := self loadableStoredSession.
	pager := GtPager createWrappedOn: (GtInspector forObject: stored).
	scripter := BlScripter new
			extent: 1600 @ 1000;
			model: stored;
			element: pager;
			yourself.
	[ scripter pulseUntilReady.
	scripter click
		// #'acp-load-stored-session';
		play.
	deadline := Time millisecondClockValue + 5000.
	[ pager pages size < 2 and: [ Time millisecondClockValue < deadline ] ]
		whileTrue: [ (Delay forMilliseconds: 10) wait.
			scripter pulseUntilReady ].
	self assert: pager pages size equals: 2.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	self assert: tool chat remoteSessionId equals: stored sessionId.
	self assert: tool chat isReady.
	self assert: tool chat client == stored newClient.
	self
		assert: (tool query // GtLACPChatElement) anyOne viewModel session == tool chat.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter ]
		ensure: [ stored newClient stop ].
	^ scripter
]

{ #category : #examples }
GtLACPExternalSessionStoreExamples >> storesLoadSessionsUsingRecordedDirectory [
	<gtExample>
	| stores loaded |
	stores := {self claudeStore.
			self codexStore}.
	loaded := OrderedCollection new.
	stores
		do: [ :store | 
			| session recordedDirectory request |
			recordedDirectory := FileLocator temp asFileReference asAbsolute.
			self
				directory: recordedDirectory
				forStoredSession: (store sessionWithId: self firstId).
			session := store
					loadSession: self firstId
					configureClient: [ :client | 
						client configuration requestTimeout: 180.
						client
							transportFactory: [ :configuration :directory | 
								self assert: directory equals: recordedDirectory.
								GtLACPExamples new transport ] ].
			[ self assert: session isReady.
			self assert: session remoteSessionId equals: self firstId.
			self assert: session directory equals: recordedDirectory.
			self assert: session client class equals: store newClient class.
			self assert: session connection requestTimeout equals: 180.
			request := session connection transport sentMessages
					detect: [ :message | (message at: 'method' ifAbsent: [ '' ]) = 'session/load' ].
			self assert: ((request at: 'params') at: 'sessionId') equals: self firstId.
			self
				assert: ((request at: 'params') at: 'cwd')
				equals: recordedDirectory fullName.
			loaded add: session ] ensure: [ session client stop ] ].
	^ loaded
]
