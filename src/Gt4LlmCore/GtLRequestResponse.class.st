Class {
	#name : #GtLRequestResponse,
	#superclass : #Object,
	#instVars : [
		'request',
		'response'
	],
	#category : 'Gt4LlmCore-Client'
}

{ #category : #'as yet unclassified' }
GtLRequestResponse >> gtRequestFor: aView [
	<gtView>
	^ aView forward
		title: 'Request';
		priority: 1;
		object: [ request ];
		view: #gtJsonFor:
]

{ #category : #'as yet unclassified' }
GtLRequestResponse >> gtResponseFor: aView [
	<gtView>
	^ aView forward
		title: 'Response';
		priority: 2;
		object: [ response ];
		view: #gtJsonFor:
]

{ #category : #accessing }
GtLRequestResponse >> request [
	^ request
]

{ #category : #accessing }
GtLRequestResponse >> request: anObject [
	request := anObject
]

{ #category : #accessing }
GtLRequestResponse >> response [
	^ response
]

{ #category : #accessing }
GtLRequestResponse >> response: anObject [
	response := anObject
]
