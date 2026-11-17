"
I wrap a Codex discovery record with its session, source file and line. rawData is the selected metadata projection; full rollout contents are loaded separately on demand.
"
Class {
	#name : #GtLACPCodexSessionRecord,
	#superclass : #GtLACPStoredSessionSource,
	#instVars : [
		'session',
		'lineNumber'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPCodexSessionRecord >> createdAt [
	^ nil
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> dateAt: aKey [
	^ (metadata at: aKey ifAbsent: [ nil ])
		ifNotNil: [ :value | [ (DateAndTime fromString: value) asUTC ] on: Error do: [ :error | nil ] ]
]

{ #category : #metadata }
GtLACPCodexSessionRecord >> dateKeys [
	^ #()
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> directory [
	^ nil
]

{ #category : #'gt - views' }
GtLACPCodexSessionRecord >> gtProvenanceFor: aView [
	"Where was this metadata recorded, and which session owns it?"

	<gtView>
	^ aView columnedList
		title: 'Provenance';
		priority: -5;
		items: [ {'Session' -> session.
				'File' -> file.
				'Line' -> lineNumber.
				'Format' -> format.
				'Selection' -> self selectionReason} ];
		column: 'Property' text: #key;
		column: 'Value' text: [ :entry | entry value asString ];
		send: #value
]

{ #category : #testing }
GtLACPCodexSessionRecord >> isIndexRecord [
	^ false
]

{ #category : #testing }
GtLACPCodexSessionRecord >> isRolloutRecord [
	^ false
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> issues [
	| result |
	result := OrderedCollection new.
	self dateKeys
		do: [ :key | 
			metadata
				at: key
				ifPresent: [ :value | 
					value
						ifNotNil: [ (self dateAt: key)
								ifNil: [ result add: (self newIssue: 'Invalid timestamp: ' , value printString) ] ] ] ].
	^ result
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> lineNumber [
	^ lineNumber
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> lineNumber: anObject [
	lineNumber := anObject
]

{ #category : #metadata }
GtLACPCodexSessionRecord >> metadataKeys [
	^ #()
]

{ #category : #private }
GtLACPCodexSessionRecord >> newIssue: aString [
	^ GtLACPStoredSessionReadIssue new
		file: file;
		lineNumber: lineNumber;
		description: aString;
		yourself
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> rawData [
	^ metadata
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> rawData: aDictionary [
	(aDictionary isKindOf: Dictionary)
		ifFalse: [ self error: 'Expected metadata dictionary' ].
	metadata := (aDictionary associations
			select: [ :entry | self metadataKeys includes: entry key ]) asDictionary
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> selectionReason [
	^ 'Source evidence'
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> session [
	^ session
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> session: anObject [
	session := anObject
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> sessionId [
	^ metadata at: 'id'
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> title [
	^ ''
]

{ #category : #accessing }
GtLACPCodexSessionRecord >> updatedAt [
	^ nil
]
