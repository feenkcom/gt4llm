Class {
	#name : #GtLOpenAIGenerateResponseAPIClient,
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
GtLOpenAIGenerateResponseAPIClient >> buildEntity [
	| entity input |
	input := OrderedCollection new.
	self messages
		do: [ :aMessage | 
			(aMessage isKindOf: GtLToolMessage)
				ifTrue: [ input add: aMessage toolCall responseInput.
					aMessage toolCall isFinished
						ifTrue: [ input add: aMessage serializeResponse ]	"(aMessage reasoning ifNil: [ {} ] ifNotNil: [ {aMessage reasoning rawData} ])
												," ]
				ifFalse: [ input add: aMessage serialize ] ].
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
GtLOpenAIGenerateResponseAPIClient >> format [
	^ format
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> isStreaming [
	^ isStreaming
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> isStreaming: anObject [
	isStreaming := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> model: anObject [
	model := anObject
]

{ #category : #'gt - extensions' }
GtLOpenAIGenerateResponseAPIClient >> request [
	^ isStreaming
		ifTrue: [ self client postStreaming: '/responses' withEntity: self buildEntity ]
		ifFalse: [ self client post: '/responses' withEntity: self buildEntity ]
]

{ #category : #'gt - extensions' }
GtLOpenAIGenerateResponseAPIClient >> serializationClass [
	^ isStreaming
		ifTrue: [ #GtOpenAIStreamedResponse asClass ]
		ifFalse: [ GtLOpenAIResponse ]
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> tools [
	^ tools
]

{ #category : #accessing }
GtLOpenAIGenerateResponseAPIClient >> tools: anObject [
	tools := anObject
]
