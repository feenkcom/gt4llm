Class {
	#name : #GtLlmRequestResponse,
	#superclass : #Object,
	#instVars : [
		'request',
		'response'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmRequestResponse >> gtRequestFor: aView [
	<gtView>
	^ aView forward
		title: 'Request';
		priority: 1;
		object: [ request ];
		view: #gtJsonFor:
]

{ #category : #'as yet unclassified' }
GtLlmRequestResponse >> gtResponseFor: aView [
	<gtView>
	^ aView forward
		title: 'Response';
		priority: 2;
		object: [ response ];
		view: #gtJsonFor:
]

{ #category : #accessing }
GtLlmRequestResponse >> request [
	^ request
]

{ #category : #accessing }
GtLlmRequestResponse >> request: anObject [
	request := anObject
]

{ #category : #accessing }
GtLlmRequestResponse >> response [
	^ response
]

{ #category : #accessing }
GtLlmRequestResponse >> response: anObject [
	response := anObject
]
