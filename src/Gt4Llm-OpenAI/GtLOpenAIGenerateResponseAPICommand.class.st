Class {
	#name : #GtLOpenAIGenerateResponseAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model',
		'messages',
		'tools',
		'format',
		'instructions',
		'isStreaming'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> buildEntity [
	| entity input |
	input := OrderedCollection new.
	self messages
		messagesDo: [ :aMessage | 
			(aMessage isKindOf: GtLToolMessage)
				ifTrue: [ input add: aMessage toolCall responseInput.
					aMessage toolCall isFinished
						ifTrue: [ input add: aMessage serializeResponse ]	
						"(aMessage reasoning ifNil: [ {} ] ifNotNil: [ {aMessage reasoning rawData} ])" ]
				ifFalse: [ input add: aMessage serializeForOpenAIResponsesAPI ] ].
	entity := {'model' -> self model.
			'stream' -> isStreaming.
			'input' -> input} asDictionary.

	format
		ifNotNil: [ entity
				at: 'text'
				put: {'format'
							-> {'type' -> 'json_schema'.
									'name' -> 'JsonSchema'.
									'schema' -> format} asDictionary} asDictionary ].

	tools isEmptyOrNil
		ifFalse: [ entity
				at: 'tools'
				put: (self tools collect: [ :aTool | aTool functionResponse ]) ].

	instructions ifNotNil: [ entity at: 'instructions' put: instructions ].

	^ entity
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> format [
	^ format
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> isStreaming [
	^ isStreaming
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> isStreaming: anObject [
	isStreaming := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> messages [
	^ messages
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> model: anObject [
	model := anObject
]

{ #category : #'gt - extensions' }
GtLOpenAIGenerateResponseAPICommand >> request [
	^ isStreaming
		ifTrue: [ self client postStreaming: '/responses' withEntity: self buildEntity ]
		ifFalse: [ self client post: '/responses' withEntity: self buildEntity ]
]

{ #category : #'gt - extensions' }
GtLOpenAIGenerateResponseAPICommand >> serializationClass [
	^ isStreaming
		ifTrue: [ #GtOpenAIStreamedResponse asClass ]
		ifFalse: [ GtLOpenAIResponse ]
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> tools [
	^ tools
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPICommand >> tools: anObject [
	tools := anObject
]
