Class {
	#name : #GtOpenAIGenerateResponseAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'messages',
		'tools',
		'format',
		'instructions'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> buildEntity [
	| entity |
	entity := {'model' -> self model.
			'stream' -> format isNil.
			'input'
				-> (self messages
						collect: [ :aMessage | 
							(aMessage isKindOf: GtLlmToolMessage)
								ifTrue: [ aMessage serializeResponse ]
								ifFalse: [ aMessage serialize ] ])} asDictionary.

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
GtOpenAIGenerateResponseAPIClient >> format [
	^ format
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> request [
	^ format
		ifNil: [ self client postStreaming: '/responses' withEntity: self buildEntity ]
		ifNotNil: [ self client post: '/responses' withEntity: self buildEntity ]
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> serializationClass [
	^ format ifNil: [ #GtOpenAIStreamedResponse asClass ] ifNotNil: [ GtOpenAIResponse ]
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> tools: anObject [
	tools := anObject
]
