Class {
	#name : #GtLOpenAIListThreadMessagesAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'thread',
		'params'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #other }
GtLOpenAIListThreadMessagesAPICommand class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLOpenAIListThreadMessagesAPICommand >> defaultParams [
	^ {'limit' -> 100.
		'order' -> 'asc'}
]

{ #category : #'as yet unclassified' }
GtLOpenAIListThreadMessagesAPICommand >> initialize [
	super initialize.

	params := self defaultParams
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPICommand >> params [
	^ params
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPICommand >> params: anObject [
	params := anObject
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPICommand >> request [
	^ self client
		get: 'threads/' , self thread , '/messages'
		withParams: self params
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPICommand >> serializationClass [
	^ GtLOpenAIMessagesGroup
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPICommand >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAIListThreadMessagesAPICommand >> thread: anObject [
	thread := anObject
]
