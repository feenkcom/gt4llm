Class {
	#name : #GtOpenAISseEvent,
	#superclass : #Object,
	#instVars : [
		'eventType',
		'data'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAISseEvent class >> fromString: aString [
	| split |
	split := aString lines.
	^ self new
		eventType: (' ' split: split first) second;
		data: (STONJSON fromString: (' ' join: (' ' split: split second) allButFirst))
]

{ #category : #accessing }
GtOpenAISseEvent >> data [
	^ data
]

{ #category : #accessing }
GtOpenAISseEvent >> data: anObject [
	data := anObject
]

{ #category : #accessing }
GtOpenAISseEvent >> eventType [
	^ eventType
]

{ #category : #accessing }
GtOpenAISseEvent >> eventType: anObject [
	eventType := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAISseEvent >> gtDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Data';
		priority: 1;
		object: [ self data ];
		view: #gtLiveFor:
]

{ #category : #'as yet unclassified' }
GtOpenAISseEvent >> toSseString [
	^ 'event: ' , self eventType
		, '
data: ' , (STONJSON toString: self data)
]
