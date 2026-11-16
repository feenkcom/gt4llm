"
I provide in-memory session files and shared inspector checks for stored-session examples. I contain no examples myself.
"
Class {
	#name : #GtLACPStoredSessionFixtures,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #assertions }
GtLACPStoredSessionFixtures >> assertViewsFor: objects [
	objects
		do: [ :object | 
			object class allMethods
				do: [ :method | 
					((method pragmaAt: #gtView) notNil
						and: [ method methodClass package name = 'Gt4Llm-ACP' ])
						ifTrue: [ | result |
							result := GtPhlowViewTester new
									testView: (object perform: method selector with: GtPhlowView empty).
							self
								assert: (result isOk or: [ result isEmpty ])
								description: object class name , '>>' , method selector ] ] ]
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> claudeRoot [
	| root |
	root := FileSystem memory root / 'claude'.
	root ensureCreateDirectory.
	self
		writeRecords: {{'type' -> 'queue-operation'.
					'sessionId' -> self firstId} asDictionary.
				{'type' -> 'user'.
					'sessionId' -> self firstId.
					'cwd' -> self projectDirectory fullName.
					'timestamp' -> '2026-10-30T13:00:00Z'.
					'slug' -> 'Readme check'.
					'message'
						-> {'content' -> 'Conversation body is not retained'} asDictionary}
					asDictionary}
		to: root / 'projects' / 'lossy-encoded-name' / (self firstId , '.jsonl').
	self
		writeRecords: {{'type' -> 'user'.
					'sessionId' -> self secondId.
					'cwd' -> (self projectDirectory fullName , '-other').
					'timestamp' -> '2026-10-29T13:00:00Z'} asDictionary}
		to: root / 'projects' / 'another-name' / (self secondId , '.jsonl').
	self
		writeRecords: {{'sessionId' -> 'subagent'.
					'cwd' -> self projectDirectory fullName} asDictionary}
		to: root / 'projects' / 'lossy-encoded-name' / self firstId / 'subagents'
				/ 'agent-sub.jsonl'.
	self
		writeRecords: {{'sessionId' -> 'orphan'.
					'cwd' -> self projectDirectory fullName} asDictionary}
		to: root / 'projects' / 'lossy-encoded-name'
				/ 'old.orphaned-123-example.jsonl'.
	^ root
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> claudeStore [
	^ (GtLACPClaudeCodeSessionStore on: self claudeRoot) read
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> codexRoot [
	| root |
	root := FileSystem memory root / 'codex'.
	root ensureCreateDirectory.
	self
		writeRecords: {{'id' -> self firstId.
					'thread_name' -> 'Current title'.
					'updated_at' -> '2026-10-30T14:00:00Z'} asDictionary.
				{'id' -> self firstId.
					'thread_name' -> 'Older title'.
					'updated_at' -> '2026-10-29T14:00:00Z'} asDictionary.
				{'id' -> self secondId.
					'thread_name' -> 'Index only'.
					'updated_at' -> '2026-10-30T12:00:00Z'} asDictionary}
		to: root / 'session_index.jsonl'.
	self
		writeRecords: {{'type' -> 'session_meta'.
					'payload'
						-> {'id' -> self firstId.
								'cwd' -> self projectDirectory fullName.
								'timestamp' -> '2026-10-30T13:00:00Z'.
								'cli_version' -> 'example'.
								'instructions' -> 'Not discovery metadata'} asDictionary} asDictionary.
				{'type' -> 'response_item'.
					'payload'
						-> {'content' -> 'Conversation body is not retained'} asDictionary}
					asDictionary}
		to: root / 'sessions' / '2026' / '10' / '30'
				/ ('rollout-example-' , self firstId , '.jsonl').
	self
		writeRecords: {{'type' -> 'session_meta'.
					'payload'
						-> {'id' -> 'other-project'.
								'cwd' -> (self projectDirectory fullName , '-other').
								'timestamp' -> '2026-10-30T11:00:00Z'} asDictionary} asDictionary}
		to: root / 'archived_sessions' / 'rollout-other.jsonl'.
	root / 'sessions' / '2026' / '10' / '30'
		/ ('rollout-2026-10-30T13-00-00-' , self compressedId , '.jsonl.zst')
		writeStreamDo: [ :stream | stream nextPutAll: 'Not decoded by the metadata reader' ].
	root / 'state_5.sqlite'
		writeStreamDo: [ :stream | stream nextPutAll: 'Not opened by the metadata reader' ].
	^ root
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> codexStore [
	^ (GtLACPCodexSessionStore on: self codexRoot) read
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> compressedId [
	^ '33333333-3333-4333-8333-333333333333'
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> directory: aDirectory forStoredSession: aSession [
	"Configure evidence-backed sessions through metadata fixtures."

	(aSession isKindOf: GtLACPCodexStoredSession)
		ifTrue: [ | metadata |
			metadata := {'id' -> aSession sessionId} asDictionary.
			aDirectory ifNotNil: [ metadata at: 'cwd' put: aDirectory fullName ].
			aSession sources removeAll.
			aSession
				addRecord: (GtLACPCodexRolloutRecord new
						file: FileSystem memory root / 'fixture.jsonl';
						lineNumber: 1;
						rawData: metadata;
						yourself).
			^ self ].
	(aSession isKindOf: GtLACPClaudeCodeStoredSession)
		ifTrue: [ aSession
				rawData: (STONJSON
						toString: (aDirectory
								ifNil: [ {'type' -> 'user'.
										'sessionId' -> aSession sessionId} asDictionary ]
								ifNotNil: [ {'type' -> 'user'.
										'sessionId' -> aSession sessionId.
										'cwd' -> aDirectory fullName} asDictionary ])).
			^ self ].
	aSession directory: aDirectory
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> firstId [
	^ '11111111-1111-4111-8111-111111111111'
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> projectDirectory [
	^ (FileLocator temp / 'gt-acp-query-example-project') asFileReference
		asAbsolute
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> secondId [
	^ '22222222-2222-4222-8222-222222222222'
]

{ #category : #fixtures }
GtLACPStoredSessionFixtures >> writeRecords: records to: aFile [
	aFile parent ensureCreateDirectory.
	aFile
		writeStreamDo: [ :stream | 
			records
				do: [ :record | 
					stream
						nextPutAll: (STONJSON toString: record);
						lf ] ]
]
