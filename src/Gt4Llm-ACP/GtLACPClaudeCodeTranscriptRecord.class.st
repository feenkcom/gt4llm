"
I wrap selected transcript metadata with its file and line. My rawData is a metadata projection: message bodies are not retained.
"
Class {
	#name : #GtLACPClaudeCodeTranscriptRecord,
	#superclass : #GtLACPObject,
	#instVars : [
		'rawData',
		'file',
		'lineNumber',
		'session'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord class >> from: aDictionary [
	| recordClass |
	recordClass := (self titleFields
			anySatisfy: [ :key | aDictionary includesKey: key ])
			ifTrue: [ GtLACPClaudeCodeTitleRecord ]
			ifFalse: [ self ].
	^ recordClass new
		rawData: (aDictionary associations
				select: [ :entry | self metadataKeys includes: entry key ]) asDictionary;
		yourself
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord class >> includesMetadata: aDictionary [
	^ (aDictionary includesKey: 'cwd')
		or: [ self titleFields anySatisfy: [ :key | aDictionary includesKey: key ] ]
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord class >> metadataKeys [
	^ #('type' 'sessionId' 'cwd' 'timestamp' 'slug' 'gitBranch' 'version' 'customTitle' 'aiTitle' 'summary')
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord class >> titleFields [
	^ #('customTitle' 'aiTitle' 'summary' 'slug')
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> belongsToSession [
	^ (rawData at: 'sessionId' ifAbsent: [ session sessionId ]) = session sessionId
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> directory [
	^ rawData at: 'cwd' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> directorySelectionReason [
	self hasDirectory ifFalse: [ ^ '' ].
	self belongsToSession ifFalse: [ ^ 'Different session' ].
	(self sameLocationAs: session directoryRecord)
		ifTrue: [ ^ 'Selected directory' ].
	^ 'Later directory record'
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> file [
	^ file
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> file: anObject [
	file := anObject
]

{ #category : #'gt - views' }
GtLACPClaudeCodeTranscriptRecord >> gtFieldsFor: aView [
	"What metadata was recorded at this file and line?"

	<gtView>
	^ aView columnedList
		title: 'Fields';
		priority: 0;
		items: [ rawData associations sorted: [ :a :b | a key <= b key ] ];
		column: 'Field' text: #key;
		column: 'Value' text: [ :entry | entry value printString ];
		send: #value
]

{ #category : #'gt - views' }
GtLACPClaudeCodeTranscriptRecord >> gtFileFor: aView [
	"Where is the original evidence, including fields not retained by discovery?"

	<gtView>
	^ aView forward
		title: 'File';
		priority: 20;
		object: [ file ];
		view: #gtContentsFor:
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> hasDirectory [
	^ rawData includesKey: 'cwd'
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> isTitleRecord [
	^ false
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> kind [
	^ rawData at: 'type' ifAbsent: [ file basename ]
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> lineNumber [
	^ lineNumber
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> lineNumber: anObject [
	lineNumber := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> printOn: aStream [
	aStream
		nextPutAll: self kind asString;
		nextPutAll: ' at ';
		nextPutAll: (lineNumber ifNil: [ 'sidecar' ] ifNotNil:
			[ :v | v asString ])
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> rawData: anObject [
	rawData := anObject
]

{ #category : #testing }
GtLACPClaudeCodeTranscriptRecord >> sameLocationAs: aRecord [
	^ aRecord notNil
		and: [ session == aRecord session
				and: [ file = aRecord file and: [ lineNumber = aRecord lineNumber ] ] ]
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> session [
	^ session
]

{ #category : #accessing }
GtLACPClaudeCodeTranscriptRecord >> session: anObject [
	session := anObject
]
