"
I validate Codex discovery records, selection explanations, lazy rollout snapshots and inspector views.
"
Class {
	#name : #GtLACPCodexStoredSessionExamples,
	#superclass : #GtLACPStoredSessionFixtures,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #fixtures }
GtLACPCodexStoredSessionExamples >> addRecord: aRecord metadata: metadata to: session [
	aRecord
		file: (session file ifNil: [ FileSystem memory root / 'fixture.jsonl' ]);
		lineNumber: 1;
		rawData: metadata.
	session addRecord: aRecord.
	^ aRecord
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> agentOrigins [
	<gtExample>
	| sessions |
	sessions := {{'source' -> 'vscode'} asDictionary -> 'session'.
			{'thread_source' -> 'guardian_review'} asDictionary -> 'guardian review'.
			{'source'
					-> {'subagent' -> {'other' -> 'guardian'} asDictionary} asDictionary}
				asDictionary -> 'guardian review'.
			{'source' -> {'subagent' -> 'review'} asDictionary} asDictionary -> 'review'.
			{'source' -> {'subagent' -> 'compact'} asDictionary} asDictionary
				-> 'compact'.
			{'source'
					-> {'subagent'
								-> {'thread_spawn'
											-> {'parent_thread_id' -> self secondId.
													'agent_path' -> '/root/design'.
													'agent_nickname' -> 'Bacon'} asDictionary} asDictionary}
							asDictionary} asDictionary -> 'delegated agent'}
			collect: [ :case | 
				| session |
				session := self discoveredSession.
				self
					addRecord: GtLACPCodexIndexRecord new
					metadata: {'id' -> self firstId.
							'thread_name' -> 'Guardian review'.
							'updated_at' -> '2027-01-01T00:00:00Z'} asDictionary
					to: session.
				self
					addRecord: GtLACPCodexRolloutRecord new
					metadata: (case key copy
							at: 'id' put: self firstId;
							yourself)
					to: session.
				self assert: session agentKind equals: case value.
				self assert: session isSubagent equals: case value ~= 'session'.
				self
					assert: session isInternalAgent
					equals: (#('guardian review' 'review' 'compact') includes: case value).
				self assert: session isGuardianReview equals: case value = 'guardian review'.
				self assert: session hasRawBytes not.
				session ].
	self assert: sessions last agentPath equals: '/root/design'.
	self assert: sessions last agentNickname equals: 'Bacon'.
	self
		assert: sessions last parentSession
				== (sessions last store sessionWithId: self secondId).
	self assertViewsFor: {sessions second originRecord}.
	^ sessions
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> directoryConflict [
	<gtExample>
	| session other |
	session := self discoveredSession.
	other := GtLACPCodexRolloutRecord new
			file: FileSystem memory root / 'conflicting.jsonl';
			lineNumber: 1;
			rawData: {'id' -> self firstId.
					'cwd' -> '/other-project'} asDictionary;
			yourself.
	session addRecord: other.
	self assert: session directory equals: self projectDirectory.
	self assert: session directoryRecord == session rolloutRecords first.
	self
		assert: other selectionReason
		equals: 'Conflicting directory; earlier source retained'.
	self
		assert: (session issues
				anySatisfy: [ :issue | issue description includesSubstring: 'Conflicting project directory' ]).
	self assert: session hasRawBytes not.
	^ session
]

{ #category : #fixtures }
GtLACPCodexStoredSessionExamples >> discoveredSession [
	^ self codexStore sessionWithId: self firstId
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> inspectorViews [
	<gtExample>
	| session store |
	session := self directoryConflict.
	store := session store.
	self
		assertViewsFor: {session.
				session indexRecords first.
				session rolloutRecords first.
				store sessionWithId: self secondId.
				store sessionWithId: self compressedId.
				(store sessionWithId: self compressedId) metadataRecords first.
				session allRecords last}.
	^ session
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> malformedBodyIsDeferred [
	<gtExample>
	| session |
	session := self discoveredSession.
	session file
		writeStreamDo: [ :stream | 
			stream
				nextPutAll: (STONJSON
						toString: {'type' -> 'session_meta'.
								'payload' -> session rolloutRecords first rawData} asDictionary);
				lf;
				nextPutAll: '{broken JSON' ].
	self assert: session issues isEmpty.
	self assert: session hasParsedRecords not.
	self assert: session recordCount equals: 1.
	self assert: session issues size equals: 1.
	self assert: session issues first lineNumber equals: 2.
	^ session
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> metadataViewsStayLazy [
	<gtExample>
	| session result |
	session := self discoveredSession.
	#(gtMetadataRecordsFor: gtTitleEvidenceFor: gtDirectoryEvidenceFor: gtDetailsFor: gtSourcesFor: gtIssuesFor:)
		do: [ :selector | 
			result := GtPhlowViewTester new
					testView: (session perform: selector with: GtPhlowView empty).
			self assert: (result isOk or: [ result isEmpty ]) description: selector.
			self assert: session hasRawBytes not.
			self assert: session hasRawData not.
			self assert: session hasParsedRecords not ].
	result := GtPhlowViewTester new
			testView: (GtLACPStoredSession sessionsView: GtPhlowView empty items: [ {session} ]).
	self assert: result isOk.
	self assert: session hasRawBytes not.
	^ session
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> partialMetadata [
	<gtExample>
	| store index compressed |
	store := self codexStore.
	index := store sessionWithId: self secondId.
	compressed := store sessionWithId: self compressedId.
	self assert: index title equals: 'Index only'.
	self assert: index issues isEmpty.
	self
		assert: compressed metadataRecords first class
		equals: GtLACPCodexCompressedRolloutRecord.
	self assert: compressed issues size equals: 1.
	{index.
		compressed}
		do: [ :session | 
			self assert: session file isNil.
			self assert: session directory isNil.
			self assert: session agentKind equals: 'unknown'.
			self assert: session hasRawBytes not ].
	^ store
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> rolloutEntriesAreLazy [
	<gtExample>
	| session |
	session := self discoveredSession.
	self assert: session hasParsedRecords not.
	self assert: session recordCount equals: 2.
	self assert: session hasRawBytes.
	self assert: session hasRawData.
	self assert: session hasParsedRecords.
	self assert: session allRecords first kind equals: 'session_meta'.
	self assert: session allRecords last kind equals: 'response_item'.
	self assert: session allRecords last session == session.
	self assert: session allRecords last lineNumber equals: 2.
	self assert: (session recordKinds at: 'response_item') equals: 1.
	^ session
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> titleSelection [
	<gtExample>
	| session record |
	session := self discoveredSession.
	self assert: session title equals: 'Current title'.
	self assert: session titleRecord == session indexRecords first.
	record := self
			addRecord: GtLACPCodexIndexRecord new
			metadata: {'id' -> self firstId.
					'thread_name' -> 'Renamed'.
					'updated_at' -> '2026-10-30T14:00:00Z'} asDictionary
			to: session.
	self assert: session title equals: 'Renamed'.
	self assert: session titleRecord == record.
	self assert: record selectionReason equals: 'Selected title'.
	record := self
			addRecord: GtLACPCodexIndexRecord new
			metadata: {'id' -> self firstId.
					'thread_name' -> 'Invalid date'.
					'updated_at' -> 'invalid'} asDictionary
			to: session.
	self assert: session title equals: 'Renamed'.
	self assert: record issues size equals: 1.
	self assert: record selectionReason equals: 'No valid update time'.
	self assert: session hasRawBytes not.
	^ session
]

{ #category : #examples }
GtLACPCodexStoredSessionExamples >> topLevelSessions [
	<gtExample>
	| store guardian delegated root |
	store := self codexStore.
	root := store sessionWithId: self firstId.
	root
		addRecord: (GtLACPCodexRolloutRecord new
				file: root file;
				lineNumber: 1;
				rawData: {'id' -> root sessionId.
						'source' -> 'vscode'} asDictionary;
				yourself).
	guardian := store sessionAt: 'guardian-child'.
	guardian
		addRecord: (GtLACPCodexRolloutRecord new
				file: root file;
				lineNumber: 1;
				rawData: {'id' -> guardian sessionId.
						'thread_source' -> 'guardian_review'.
						'parent_thread_id' -> root sessionId.
						'cwd' -> self projectDirectory fullName} asDictionary;
				yourself).
	delegated := store sessionAt: 'delegated-child'.
	delegated
		addRecord: (GtLACPCodexRolloutRecord new
				file: root file;
				lineNumber: 1;
				rawData: {'id' -> delegated sessionId.
						'cwd' -> self projectDirectory fullName.
						'source'
							-> {'subagent'
										-> {'thread_spawn'
													-> {'parent_thread_id' -> root sessionId.
															'agent_path' -> '/root/design'} asDictionary} asDictionary}
									asDictionary} asDictionary;
				yourself).
	self assert: (store sessions includes: root).
	self assert: (store sessions includes: guardian) not.
	self assert: (store sessions includes: delegated) not.
	self assert: (store allSessions includes: guardian).
	self assert: (store subagents includes: delegated).
	self assert: (store internalAgents includes: guardian).
	self assert: (store sessionWithId: guardian sessionId) == guardian.
	self assert: guardian parentSession == root.
	self
		assert: (store allSessions allSatisfy: [ :session | session hasRawBytes not ]).
	self assert: (store sessions includes: (store sessionWithId: self secondId)).
	self
		assert: (store sessions includes: (store sessionWithId: self compressedId)).
	self
		assert: (store sessionWithId: self compressedId) agentKind
		equals: 'unknown'.
	self
		assert: ((store forDirectory: self projectDirectory) sessions noneSatisfy: #isSubagent).
	self
		assert: ((store forDirectory: self projectDirectory) unresolvedSessions
				noneSatisfy: #isSubagent).
	self assertViewsFor: {store}.
	self
		assert: (store allSessions allSatisfy: [ :session | session hasRawBytes not ]).
	^ store
]
