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
GtLAnthropicCompleteChatAPICommand >> buildEntity [
	| newEntity serializedMessages |
	
	newEntity := {
		'model' -> model.
		'max_tokens' -> maxTokens} asDictionary.
			
	serializedMessages := OrderedCollection new.
	self messages
		messagesDo: [ :aMessage | 
			aMessage isToolMessage
				ifTrue: [ aMessage toolCall isFinished
						ifTrue: [ 
							serializedMessages 
								add: aMessage toolCall responseInput.
							serializedMessages 
								add: aMessage serializeForAnthropicMessagesAPI ] ]
				ifFalse: [ serializedMessages 
					add: aMessage serializeForAnthropicMessagesAPI ] ].
				
	newEntity at: 'messages' put: serializedMessages asArray.
			
	self tools
		ifNotNil: [ 
			newEntity at: 'tools' put: (self tools 
				collect: [:each |each functionAnthropic]
				as: Array) ].

	self system ifNotNil: [ newEntity at: 'system' put: system ].
	self format ifNotNil: [ newEntity at: 'output_format' put: format ].

	^ newEntity
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
	^ self client post: '/messages' withEntity: self buildEntity
]

{ #category : #'as yet unclassified' }
GtLAnthropicCompleteChatAPICommand >> serializationClass [
	^ GtAnthropicResponse
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
