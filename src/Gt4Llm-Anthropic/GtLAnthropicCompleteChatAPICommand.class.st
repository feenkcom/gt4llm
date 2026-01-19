Class {
	#name : #GtLAnthropicCompleteChatAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model',
		'messages',
		'maxTokens',
		'tools',
		'system',
		'format'
	],
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #'as yet unclassified' }
GtLAnthropicCompleteChatAPICommand >> entity [
	| anEntity |
	anEntity := {'model' -> model.
			'messages' -> (messages collect: #serialize).
			'max_tokens' -> maxTokens} asDictionary.


	self tools
		ifNotNil: [ anEntity at: 'tools' put: (self tools collect: #functionAnthropic) ].

	self system ifNotNil: [ anEntity at: 'system' put: system ].
	self format ifNotNil: [ anEntity at: 'output_format' put: format ].

	^ anEntity
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> format [
	^ format
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> maxTokens [
	^ maxTokens
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> maxTokens: anObject [
	maxTokens := anObject
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> messages [
	^ messages
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtLAnthropicCompleteChatAPICommand >> request [
	^ self client post: '/messages' withEntity: self entity
]

{ #category : #'as yet unclassified' }
GtLAnthropicCompleteChatAPICommand >> serializationClass [
	^ GtAnthropicChatMessage
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> system [
	^ system
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> system: anObject [
	system := anObject
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> tools [
	^ tools
]

{ #category : #accessing }
GtLAnthropicCompleteChatAPICommand >> tools: anObject [
	tools := anObject
]
