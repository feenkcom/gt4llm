"
I wrap a JSONL rollout entry loaded on demand, including its payload and exact file/line provenance.
"
Class {
	#name : #GtLACPCodexRolloutEntry,
	#superclass : #GtLACPObject,
	#instVars : [
		'rawData',
		'session',
		'file',
		'lineNumber'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPCodexRolloutEntry >> file [
	^ file
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> file: anObject [
	file := anObject
]

{ #category : #'gt - views' }
GtLACPCodexRolloutEntry >> gtFieldsFor: aView [
	"What fields are present in this rollout entry?"

	<gtView>
	^ aView columnedList
		title: 'Fields';
		priority: 0;
		items: [ rawData associations ];
		column: 'Field' text: #key;
		column: 'Value' text: [ :entry | entry value printString ];
		send: #value
]

{ #category : #'gt - views' }
GtLACPCodexRolloutEntry >> gtFileFor: aView [
	"Where is the original JSONL entry?"

	<gtView>
	^ aView forward
		title: 'File';
		priority: 10;
		object: [ file ];
		view: #gtContentsFor:
]

{ #category : #'gt - views' }
GtLACPCodexRolloutEntry >> gtPayloadFor: aView [
	"What payload was recorded at this line?"

	<gtView>
	^ aView forward
		title: 'Payload';
		priority: -5;
		object: [ self payload ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> kind [
	^ rawData at: 'type' ifAbsent: [ 'untyped' ]
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> lineNumber [
	^ lineNumber
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> lineNumber: anObject [
	lineNumber := anObject
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> payload [
	^ rawData at: 'payload' ifAbsent: [ Dictionary new ]
]

{ #category : #printing }
GtLACPCodexRolloutEntry >> printOn: aStream [
	aStream
		nextPutAll: self kind asString;
		nextPutAll: ' at ';
		print: lineNumber
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> session [
	^ session
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> session: anObject [
	session := anObject
]

{ #category : #accessing }
GtLACPCodexRolloutEntry >> timestamp [
	^ rawData at: 'timestamp' ifAbsent: [ '' ]
]
