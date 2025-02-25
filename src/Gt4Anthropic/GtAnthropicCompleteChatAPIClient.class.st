Class {
	#name : #GtAnthropicCompleteChatAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'messages',
		'maxTokens',
		'tools',
		'system'
	],
	#category : #'Gt4Anthropic-Client'
}

{ #category : #'as yet unclassified' }
GtAnthropicCompleteChatAPIClient >> entity [
	| anEntity |
	anEntity := {'model' -> model.
			'messages' -> (messages collect: #serialize).
			'max_tokens' -> maxTokens} asDictionary.


	self tools
		ifNotNil: [ anEntity at: 'tools' put: (self tools collect: #functionAnthropic) ].

	self system ifNotNil: [ anEntity at: 'system' put: system ].

	^ anEntity
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> maxTokens [
	^ maxTokens
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> maxTokens: anObject [
	maxTokens := anObject
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtAnthropicCompleteChatAPIClient >> request [
	^ self client post: '/messages' withEntity: self entity
]

{ #category : #'as yet unclassified' }
GtAnthropicCompleteChatAPIClient >> serializationClass [
	^ GtAnthropicChatMessage
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> system [
	^ system
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> system: anObject [
	system := anObject
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> tools [
	^ tools
]

{ #category : #accessing }
GtAnthropicCompleteChatAPIClient >> tools: anObject [
	tools := anObject
]
