Class {
	#name : #GtLToolPreviousRequestResponse,
	#superclass : #Object,
	#instVars : [
		'toolCallIndex',
		'followingRequestResponse',
		'previousRequestResponse'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #views }
GtLToolPreviousRequestResponse >> gtFollowingRequestFor: aView [
	<gtView>
	^ aView forward
		title: 'Following request JSON';
		priority: 12;
		object: [ followingRequestResponse ];
		view: #gtRequestFor:
]

{ #category : #views }
GtLToolPreviousRequestResponse >> gtFollowingRequestTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Following request JSON tree';
		priority: 11;
		object: [ followingRequestResponse ];
		view: #gtRequestJsonTreeFor:
]

{ #category : #views }
GtLToolPreviousRequestResponse >> gtPreviousRequestResponseFor: aView [
	<gtView>
	^ aView forward
		title: 'Previous response JSON';
		priority: 2;
		object: [ previousRequestResponse ];
		view: #gtResponseFor:
]

{ #category : #views }
GtLToolPreviousRequestResponse >> gtPreviousResponseTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Previous response JSON tree';
		priority: 1;
		object: [ previousRequestResponse ];
		view: #gtResponseJsonTreeFor:
]

{ #category : #accessing }
GtLToolPreviousRequestResponse >> previousRequestResponse [
	^ previousRequestResponse
]

{ #category : #accessing }
GtLToolPreviousRequestResponse >> previousRequestResponse: anObject [
	previousRequestResponse := anObject
]

{ #category : #accessing }
GtLToolPreviousRequestResponse >> resultUsageDetails [
	^followingRequestResponse ifNotNil: [ :each | each resultUsageDetails ]
]

{ #category : #accessing }
GtLToolPreviousRequestResponse >> toolCallIndex [
	^ toolCallIndex
]

{ #category : #accessing }
GtLToolPreviousRequestResponse >> toolCallIndex: anObject [
	toolCallIndex := anObject
]

{ #category : #accessing }
GtLToolPreviousRequestResponse >> withFollowingRequestResponse: aRequestResponse [
	followingRequestResponse := aRequestResponse.
	^ self
]
