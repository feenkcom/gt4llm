Class {
	#name : #GtOpenAIListThreadMessagesAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'thread',
		'params'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIListThreadMessagesAPIClient >> defaultParams [
	^ {'limit' -> 100.
		'order' -> 'asc'}
]

{ #category : #'as yet unclassified' }
GtOpenAIListThreadMessagesAPIClient >> initialize [
	super initialize.

	params := self defaultParams
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> params [
	^ params
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> params: anObject [
	params := anObject
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> request [
	^ self client
		get: 'threads/' , self thread , '/messages'
		withParams: self params
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> serializationClass [
	^ GtOpenAIMessagesGroup
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> thread: anObject [
	thread := anObject
]
