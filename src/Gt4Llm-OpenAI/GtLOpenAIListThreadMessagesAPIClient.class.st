Class {
	#name : #GtLOpenAIListThreadMessagesAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'thread',
		'params'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #other }
GtLOpenAIListThreadMessagesAPIClient class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLOpenAIListThreadMessagesAPIClient >> defaultParams [
	^ {'limit' -> 100.
		'order' -> 'asc'}
]

{ #category : #'as yet unclassified' }
GtLOpenAIListThreadMessagesAPIClient >> initialize [
	super initialize.

	params := self defaultParams
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPIClient >> params [
	^ params
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPIClient >> params: anObject [
	params := anObject
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPIClient >> request [
	^ self client
		get: 'threads/' , self thread , '/messages'
		withParams: self params
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPIClient >> serializationClass [
	^ GtLOpenAIMessagesGroup
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPIClient >> thread: anObject [
	thread := anObject
]
