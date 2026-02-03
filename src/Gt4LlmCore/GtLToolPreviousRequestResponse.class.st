Class {
	#name : #GtLToolPreviousRequestResponse,
	#superclass : #Object,
	#instVars : [
		'toolCallIndex',
		'followingRequestResponse',
		'previousRequestResponse'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLToolPreviousRequestResponse >> previousRequestResponse [
	^ previousRequestResponse
]

{ #category : #accessing }
GtLToolPreviousRequestResponse >> previousRequestResponse: anObject [
	previousRequestResponse := anObject
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
