Class {
	#name : #GtLReplyMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'userMessage',
		'toolMessages',
		'assistantMessage'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLReplyMessage class >> leJsonV4Name [
	^ #gtLReplyMessage
]

{ #category : #'api - message' }
GtLReplyMessage >> addToolMessage: aToolMessage [
	self toolMessages: (self toolMessages copyWith: aToolMessage)
]

{ #category : #accessing }
GtLReplyMessage >> assistantMessage [
	^ assistantMessage
]

{ #category : #accessing }
GtLReplyMessage >> assistantMessage: anObject [
	assistantMessage := anObject
]

{ #category : #accessing }
GtLReplyMessage >> content [
	^ self currentMessageDo: #content ifAbsent: [ super content ]
]

{ #category : #accessing }
GtLReplyMessage >> createdAt [
	^ self currentMessageDo: #createdAt ifAbsent: [ super createdAt ]
]

{ #category : #'api - message' }
GtLReplyMessage >> currentMessage [
	"Return a last message that should be used
	to receive a LLM server response."

	<return: #GtLChatMessage>
	^ self currentMessageDo: [ :aMessage | aMessage ] ifAbsent: [ self ]
]

{ #category : #'api - message' }
GtLReplyMessage >> currentMessageDo: aBlock ifAbsent: anAbsentBlock [
	"Return a last message that should be used
	to receive a LLM server response."

	<return: #GtLChatMessage>
	assistantMessage ifNotNil: [ ^ aBlock value: assistantMessage ].
	toolMessages ifNotEmpty: [ ^ aBlock value: toolMessages last ].
	^ anAbsentBlock value
]

{ #category : #initialization }
GtLReplyMessage >> initialize [
	super initialize.
	toolMessages := #()
]

{ #category : #testing }
GtLReplyMessage >> isReplyMessage [
	^ true
]

{ #category : #'api - message' }
GtLReplyMessage >> messagesDo: aBlock [
	"Evaluate do block on all messages.
	Note that some messages may be a composition of other messages.
	
	In this case, user message is ignored since 
	it is a standalone message in the chat messages collection."

	self toolMessages do: aBlock.
	self assistantMessage ifNotNil: aBlock
]

{ #category : #accessing }
GtLReplyMessage >> role [
	^ self currentMessageDo: #role ifAbsent: [ super role ]
]

{ #category : #accessing }
GtLReplyMessage >> toolMessages [
	^ toolMessages
]

{ #category : #accessing }
GtLReplyMessage >> toolMessages: anObject [
	toolMessages := anObject
]

{ #category : #accessing }
GtLReplyMessage >> userMessage [
	^ userMessage
]

{ #category : #accessing }
GtLReplyMessage >> userMessage: anObject [
	userMessage := anObject
]
