"
I provide in-memory transcript fixtures for metadata provenance, title resolution and inspector views.
"
Class {
	#name : #GtLACPClaudeCodeTranscriptExamples,
	#superclass : #GtLACPStoredSessionFixtures,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> browsingDoesNotDecodeSnapshot [
	<gtExample>
	| session result |
	session := self
			transcriptWithRecords: {{'type' -> 'user'.
						'sessionId' -> self firstId.
						'cwd' -> self projectDirectory fullName.
						'timestamp' -> '2026-11-01T10:00:00Z'} asDictionary.
					self titleRecord: 'Révision 🦊' field: 'aiTitle'}.
	self assert: session hasRawBytes not.
	self assert: session title equals: 'Révision 🦊'.
	self assert: session directory equals: self projectDirectory.
	self assert: session createdAt notNil.
	self assert: session hasRawBytes.
	self assert: session hasRawData not.
	self assert: session hasParsedRecords not.
	result := GtPhlowViewTester new
			testView: (GtLACPStoredSession sessionsView: GtPhlowView empty items: [ {session} ]).
	self assert: result isOk.
	self assert: session hasRawData not.
	self assert: session hasParsedRecords not.
	^ session
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> decodedTextSharesByteSnapshot [
	<gtExample>
	| session |
	session := self browsingDoesNotDecodeSnapshot.
	session file writeStreamDo: [ :stream | stream nextPutAll: '{}' ].
	self assert: (session rawData includesSubstring: 'Révision 🦊').
	self assert: session recordCount equals: 2.
	self assert: session title equals: 'Révision 🦊'.
	session read.
	self assert: session hasRawBytes not.
	self assert: session hasRawData not.
	self assert: session title isEmpty.
	self assert: session directory isNil.
	self assert: session createdAt isNil.
	self assert: session rawData equals: '{}'.
	^ session
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> detailsParseConversationRecordsOnDemand [
	<gtExample>
	| session result |
	session := self claudeStore sessionWithId: self firstId.
	session
		rawData: (String
				streamContents: [ :stream | 
					stream
						nextPutAll: (STONJSON
								toString: {'type' -> 'user'.
										'sessionId' -> self firstId.
										'cwd' -> self projectDirectory fullName.
										'timestamp' -> '2026-11-01T10:00:00Z'} asDictionary);
						lf;
						nextPutAll: '{"type":"assistant","message":';
						lf;
						nextPutAll: (STONJSON toString: (self titleRecord: 'Révision 🦊' field: 'aiTitle')) ]).
	self assert: session title equals: 'Révision 🦊'.
	self assert: session directory equals: self projectDirectory.
	self assert: session createdAt notNil.
	session
		sortKey;
		sources.
	self assert: session hasParsedRecords not.
	result := GtPhlowViewTester new
			testView: (GtLACPStoredSession sessionsView: GtPhlowView empty items: [ {session} ]).
	self assert: result isOk.
	self assert: session hasParsedRecords not.
	self assert: session issues size equals: 1.
	self assert: session issues first lineNumber equals: 2.
	self assert: session hasParsedRecords.
	self assert: session recordCount equals: 2.
	self
		assert: session directoryRecord directorySelectionReason
		equals: 'Selected directory'.
	self assert: session selectedTitleRecord selectionReason equals: 'Selected'.
	^ session
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> inspectorViews [
	<gtExample>
	| session |
	session := self
			transcriptWithRecords: {{'type' -> 'user'.
						'sessionId' -> self firstId.
						'cwd' -> self projectDirectory fullName} asDictionary.
					self titleRecord: 'Title' field: 'aiTitle'}.
	self
		assertViewsFor: {session.
				session titleRecords first.
				session records first}.
	^ session
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> lateTitleAndDirectory [
	<gtExample>
	| entries transcript store session |
	entries := ((1 to: 60)
			collect: [ :index | 
				{'type' -> 'assistant'.
					'message' -> 'Body is not retained'} asDictionary ]) asOrderedCollection.
	entries
		add: {'type' -> 'user'.
				'cwd' -> self projectDirectory fullName.
				'sessionId' -> self firstId.
				'timestamp' -> '2026-10-30T13:00:00Z'.
				'message' -> 'Body is not retained'} asDictionary.
	entries add: (self titleRecord: 'Title beyond the old limit' field: 'aiTitle').
	transcript := self transcriptWithRecords: entries.
	store := (GtLACPClaudeCodeSessionStore on: transcript file parent parent parent)
			read.
	session := store sessionWithId: self firstId.
	self assert: session directory equals: self projectDirectory.
	self assert: session title equals: 'Title beyond the old limit'.
	self assert: transcript recordCount equals: 62.
	self assert: transcript records size equals: 2.
	self
		assert: (transcript records
				allSatisfy: [ :record | (record rawData includesKey: 'message') not ]).
	self assert: (transcript recordKinds at: 'assistant') equals: 60.
	self assert: store issues isEmpty.
	^ session
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> sidecarTitlePrecedence [
	<gtExample>
	| session sidecar |
	session := self
			transcriptWithRecords: {self titleRecord: 'Generated' field: 'aiTitle'}.
	sidecar := session file parent / self firstId / 'custom-title.json'.
	sidecar parent ensureCreateDirectory.
	sidecar
		writeStreamDo: [ :stream | 
			stream
				nextPutAll: (STONJSON toString: {'customTitle' -> 'Sidecar'} asDictionary) ].
	self assert: session title equals: 'Sidecar'.
	self assert: session selectedTitleRecord file equals: sidecar.
	self assert: session selectedTitleRecord lineNumber isNil.
	self
		writeRecords: {self titleRecord: 'Transcript rename' field: 'customTitle'}
		to: session file.
	session read.
	self assert: session title equals: 'Transcript rename'.
	^ session
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> titleRecord: text field: field [
	^ {'type' -> field.
		'sessionId' -> self firstId.
		field -> text} asDictionary
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> titleSelection [
	<gtExample>
	| session foreign |
	session := self
			transcriptWithRecords: {self titleRecord: 'Initial' field: 'aiTitle'.
					self titleRecord: 'Revised' field: 'aiTitle'}.
	self assert: session title equals: 'Revised'.
	self
		assert: session titleRecords first selectionReason
		equals: 'Superseded by later record'.
	foreign := self titleRecord: 'Foreign' field: 'customTitle'.
	foreign at: 'sessionId' put: self secondId.
	session
		rawData: (String
				streamContents: [ :stream | 
					{self titleRecord: 'Explicit' field: 'customTitle'.
						self titleRecord: 'Generated' field: 'aiTitle'.
						self titleRecord: '   ' field: 'customTitle'.
						self titleRecord: 42 field: 'customTitle'.
						foreign}
						do: [ :record | 
							stream
								nextPutAll: (STONJSON toString: record);
								lf ] ]).
	self assert: session title equals: 'Explicit'.
	self
		assert: session titleRecords last selectionReason
		equals: 'Different session'.
	self
		assert: session titleRecords second selectionReason
		equals: 'Lower priority'.
	session rawData: '{}'.
	self assert: session selectedTitleRecord isNil.
	self assert: session title isEmpty.
	^ session
]

{ #category : #examples }
GtLACPClaudeCodeTranscriptExamples >> transcriptWithRecords: entries [
	| file |
	file := FileSystem memory root / 'projects' / 'example'
			/ (self firstId , '.jsonl').
	self writeRecords: entries to: file.
	^ GtLACPClaudeCodeStoredSession on: file
]
