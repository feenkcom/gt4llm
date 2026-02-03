Class {
	#name : #GtLRequestResponse,
	#superclass : #Object,
	#instVars : [
		'request',
		'response',
		'result'
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
	<return: #ZnRequest>
	^ request
]

{ #category : #accessing }
GtLRequestResponse >> request: anObject [
	request := anObject
]

{ #category : #accessing }
GtLRequestResponse >> response [
	<return: #ZnResponse>
	^ response
]

{ #category : #accessing }
GtLRequestResponse >> response: anObject [
	response := anObject
]

{ #category : #accessing }
GtLRequestResponse >> result [
	^ result
]

{ #category : #accessing }
GtLRequestResponse >> result: anObject [
	result := anObject
]
