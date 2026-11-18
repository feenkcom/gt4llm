"
I own a Codex stored session's typed discovery records. Index records explain title and update-time selection; rollout-header records explain directory and creation time; compressed records expose filename-only coverage. List properties are cached derivations of these small records. Browsing never loads full rollout bytes. rawBytes, rawData and allRecords lazily expose the first uncompressed rollout for detailed views, with file/line provenance on entries. read invalidates detail and derived caches; rereading the store refreshes discovery records. Metadata views and diagnostics do not force the rollout body.
"
Class {
	#name : #GtLACPCodexStoredSession,
	#superclass : #GtLACPFileStoredSession,
	#instVars : [
		'originRecord'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #adding }
GtLACPCodexStoredSession >> addRecord: aRecord [
	aRecord sessionId = sessionId
		ifFalse: [ self error: 'Record belongs to another session' ].
	aRecord session: self.
	self addSource: aRecord.
	self read
]

{ #category : #accessing }
GtLACPCodexStoredSession >> agentKind [
	^ self originRecord
		ifNil: [ 'unknown' ]
		ifNotNil: [ :record | record agentKind ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> agentNickname [
	^ self originRecord ifNotNil: [ :record | record agentNickname ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> agentPath [
	^ self originRecord ifNotNil: [ :record | record agentPath ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> createdAt [
	^ createdAt
		ifNil: [ createdAt := self createdAtRecord ifNotNil: [ :record | record createdAt ] ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> createdAtRecord [
	| selected |
	selected := nil.
	self rolloutRecords
		do: [ :record | record createdAt ifNotNil: [ selected := record ] ].
	^ selected
]

{ #category : #accessing }
GtLACPCodexStoredSession >> directory [
	^ directory
		ifNil: [ directory := self directoryRecord ifNotNil: [ :record | record directory ] ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> directoryRecord [
	^ self rolloutRecords
		detect: [ :record | record directory notNil ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> file [
	"Full entries are read from the first uncompressed rollout; all sources remain navigable."

	^ self rolloutRecords
		ifEmpty: [ nil ]
		ifNotEmpty: [ :records | records first file ]
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtDirectoryEvidenceFor: aView [
	"Which rollout supplies the directory, and do other rollouts disagree?"

	<gtView>
	^ aView columnedList
		title: 'Directory evidence';
		priority: 6;
		items: [ self rolloutRecords ];
		column: 'Directory'
			text: [ :record | 
				record directory
					ifNil: [ '(unknown)' ]
					ifNotNil: [ :directory | directory fullName ] ];
		column: 'Created' text: [ :record | record createdAt ifNil: [ '(unknown)' ] ];
		column: 'File' text: [ :record | record file fullName ];
		column: 'Decision' text: #selectionReason
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtIssuesFor: aView [
	"What discovery problems and already-observed rollout parsing problems affect this session?"

	<gtView>
	^ aView columnedList
		title: 'Read problems';
		priority: 15;
		items: [ self issues ];
		column: 'File' text: [ :issue | issue file fullName ];
		column: 'Line' text: [ :issue | issue lineNumber ifNil: [ '' ] ];
		column: 'Reason' text: #description
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtKindsFor: aView [
	"What kinds of entries occur in the primary rollout?"

	<gtView>
	self file ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Record kinds';
		priority: 25;
		items: [ self recordKinds associations sorted: [ :a :b | a key <= b key ] ];
		column: 'Kind' text: #key;
		column: 'Count' text: #value
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtMetadataRecordsFor: aView [
	"What index, rollout-header and compressed-file evidence describes this session?"

	<gtView>
	^ aView columnedList
		title: 'Metadata records';
		priority: -5;
		items: [ self metadataRecords ];
		column: 'Format' text: #format;
		column: 'File' text: [ :record | record file fullName ];
		column: 'Line' text: [ :record | record lineNumber ifNil: [ '' ] ];
		column: 'Selection' text: #selectionReason
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtOriginFor: aView [
	"What recorded origin distinguishes internal, delegated and ordinary sessions?"

	<gtView>
	self originRecord ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Agent origin';
		priority: 8;
		object: [ self originRecord ];
		view: #gtOriginFor:
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtRawDataFor: aView [
	"What exact primary-rollout JSONL snapshot do the full entries derive from?"

	<gtView>
	self file ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Raw data';
		priority: 30;
		text: [ self rawData ]
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtRolloutEntriesFor: aView [
	"What entries occur in the primary uncompressed rollout? Load its body only for this view."

	<gtView>
	self file ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Rollout entries';
		priority: 20;
		items: [ self allRecords ];
		column: 'Line' text: #lineNumber;
		column: 'Kind' text: #kind;
		column: 'Timestamp' text: #timestamp
]

{ #category : #'gt - views' }
GtLACPCodexStoredSession >> gtTitleEvidenceFor: aView [
	"Which index entry supplies the title, and why are other entries not selected?"

	<gtView>
	^ aView columnedList
		title: 'Title evidence';
		priority: -10;
		items: [ self indexRecords ];
		column: 'Title' text: #title;
		column: 'Updated' text: [ :record | record updatedAt ifNil: [ '(unknown)' ] ];
		column: 'Line' text: #lineNumber;
		column: 'Decision' text: #selectionReason
]

{ #category : #accessing }
GtLACPCodexStoredSession >> indexRecords [
	^ self metadataRecords select: #isIndexRecord
]

{ #category : #testing }
GtLACPCodexStoredSession >> isGuardianReview [
	^ self originRecord
		ifNil: [ false ]
		ifNotNil: [ :record | record isGuardianReview ]
]

{ #category : #testing }
GtLACPCodexStoredSession >> isInternalAgent [
	^ self originRecord
		ifNil: [ false ]
		ifNotNil: [ :record | record isInternalAgent ]
]

{ #category : #testing }
GtLACPCodexStoredSession >> isSubagent [
	^ self originRecord ifNil: [ false ] ifNotNil: [ :record | record isSubagent ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> issues [
	"Discovery problems and problems from details already requested; do not force the body."

	| result selected |
	result := parseIssues copy.
	self metadataRecords do: [ :record | result addAll: record issues ].
	selected := self directoryRecord.
	selected
		ifNotNil: [ self rolloutRecords
				do: [ :record | 
					(record directory notNil and: [ record directory ~= selected directory ])
						ifTrue: [ result
								add: (record newIssue: 'Conflicting project directory; earlier source retained') ] ] ].
	^ result
]

{ #category : #accessing }
GtLACPCodexStoredSession >> metadataRecords [
	^ sources select: [ :source | source isKindOf: GtLACPCodexSessionRecord ]
]

{ #category : #loading }
GtLACPCodexStoredSession >> newClient [
	^ GtLACPCodexClient new
]

{ #category : #accessing }
GtLACPCodexStoredSession >> originRecord [
	^ originRecord
		ifNil: [ originRecord := self rolloutRecords detect: #hasOrigin ifNone: [ nil ] ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> parentSession [
	^ self parentThreadId
		ifNotNil: [ :identifier | store sessionWithId: identifier ifAbsent: [ nil ] ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> parentThreadId [
	^ self originRecord ifNotNil: [ :record | record parentThreadId ]
]

{ #category : #reading }
GtLACPCodexStoredSession >> read [
	super read.
	originRecord := nil.
	^ self
]

{ #category : #private }
GtLACPCodexStoredSession >> recordFrom: aDictionary [
	^ GtLACPCodexRolloutEntry new
		rawData: aDictionary;
		yourself
]

{ #category : #accessing }
GtLACPCodexStoredSession >> records [
	^ self metadataRecords
]

{ #category : #accessing }
GtLACPCodexStoredSession >> rolloutRecords [
	^ self metadataRecords select: #isRolloutRecord
]

{ #category : #accessing }
GtLACPCodexStoredSession >> source [
	^ self originRecord ifNotNil: [ :record | record source ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> threadSource [
	^ self originRecord ifNotNil: [ :record | record threadSource ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> title [
	^ title
		ifNil: [ title := self titleRecord ifNil: [ '' ] ifNotNil: [ :record | record title ] ]
]

{ #category : #accessing }
GtLACPCodexStoredSession >> titleRecord [
	| selected latest |
	selected := nil.
	latest := nil.
	self indexRecords
		do: [ :record | 
			| updated |
			updated := record updatedAt.
			(latest isNil or: [ updated notNil and: [ updated >= latest ] ])
				ifTrue: [ selected := record.
					updated ifNotNil: [ latest := updated ] ] ].
	^ selected
]

{ #category : #accessing }
GtLACPCodexStoredSession >> updatedAt [
	^ updatedAt
		ifNil: [ updatedAt := self titleRecord ifNotNil: [ :record | record updatedAt ] ]
]
