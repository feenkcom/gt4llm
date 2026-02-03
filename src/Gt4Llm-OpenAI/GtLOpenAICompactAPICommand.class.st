Class {
	#name : #GtLOpenAICompactAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'instructions',
		'model',
		'messages'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAICompactAPICommand >> buildEntity [
	| entity input |
	input := OrderedCollection new.
	
	self messages
		messagesDo: [ :aMessage | 
			aMessage isToolMessage
				ifTrue: [ aMessage toolCall isFinished
						ifTrue: [ input add: aMessage toolCall responseInput.
							input add: aMessage serializeForOpenAIResponsesAPI ] ]
				ifFalse: [ input add: aMessage serializeForOpenAIResponsesAPI ] ].
	entity := {
			'model' -> self model.
			'input' -> input } asDictionary.

	instructions ifNotNil: [ entity at: 'instructions' put: instructions ].

	^ entity
]

{ #category : #accessing }
GtLOpenAICompactAPICommand >> instructions [
	^instructions
]

{ #category : #accessing }
GtLOpenAICompactAPICommand >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLOpenAICompactAPICommand >> messages [
	^messages
]

{ #category : #accessing }
GtLOpenAICompactAPICommand >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLOpenAICompactAPICommand >> model [
	^model
]

{ #category : #accessing }
GtLOpenAICompactAPICommand >> model: anObject [
	model := anObject
]

{ #category : #api }
GtLOpenAICompactAPICommand >> request [
	^ self client
		post: '/responses/compact'
		withEntity: self buildEntity
]

{ #category : #accessing }
GtLOpenAICompactAPICommand >> serializationClass [
	^ GtLOpenAIResponse
]
