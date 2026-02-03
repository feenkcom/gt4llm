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
		title: 'Request JSON';
		priority: 2;
		object: [ request ];
		view: #gtJsonFor:
]

{ #category : #views }
GtLRequestResponse >> gtRequestJsonTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Request JSON tree';
		priority: 0;
		object: [ STONJSON fromString: request contents ];
		view: #gtTreeFor:context:
]

{ #category : #'as yet unclassified' }
GtLRequestResponse >> gtResponseFor: aView [
	<gtView>
	^ aView forward
		title: 'Response JSON';
		priority: 12;
		object: [ response ];
		view: #gtJsonFor:
]

{ #category : #views }
GtLRequestResponse >> gtResponseJsonTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Response JSON tree';
		priority: 11;
		object: [ STONJSON fromString: response contents ];
		view: #gtTreeFor:context:
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
