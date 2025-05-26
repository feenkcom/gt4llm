Class {
	#name : #GtGeminiGenerateContentsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'messages',
		'model',
		'instructions',
		'tools',
		'format',
		'entities'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiGenerateContentsAPIClient >> buildEntity [
	| entity |
	entity := {'contents' -> self buildMessageEntities} asDictionary.

	instructions
		ifNotNil: [ entity
				at: 'system_instruction'
				put: {'parts' -> {{'text' -> self instructions} asDictionary}} asDictionary ].

	tools isEmptyOrNil
		ifFalse: [ entity
				at: 'tools'
				put: {{'functionDeclarations' -> (tools collect: [ :aTool | aTool functionGemini ])}
							asDictionary} ].

	(format isNotNil and: [ tools isEmptyOrNil ])
		ifTrue: [ entity
				at: 'generationConfig'
				put: {'responseMimeType' -> 'application/json'.
						'responseSchema' -> format} asDictionary ].

	^ entity
]

{ #category : #'as yet unclassified' }
GtGeminiGenerateContentsAPIClient >> buildMessageEntities [
	entities := OrderedCollection new.
	self messages
		do: [ :aMessage | 
			aMessage isToolRole
				ifTrue: [ entities
						add: {'role' -> 'assistant'.
								'parts'
									-> {'functionCall'
												-> {'name' -> aMessage toolCall name.
														'args' -> aMessage toolCall arguments} asDictionary} asDictionary}
								asDictionary;
						add: {'role' -> 'user'.
								'parts'
									-> {'functionResponse'
												-> {'name' -> aMessage toolCall name.
														'response' -> {'output' -> aMessage output} asDictionary}
														asDictionary} asDictionary} asDictionary ]
				ifFalse: [ entities
						add: {'role'
									-> (aMessage role = 'assistant' ifTrue: [ 'model' ] ifFalse: [ aMessage role ]).
								'parts'
									-> ({{'text' -> aMessage contentText} asDictionary}
											, (aMessage images
													collect: [ :aFile | 
														{'inline_data'
																-> {'mime_type' -> 'image/jpeg'.
																		'data' -> aFile} asDictionary} asDictionary ]))} asDictionary ] ].
	^ entities
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> format [
	^ format
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> instructions [
	^ instructions
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtGeminiGenerateContentsAPIClient >> request [
	^ self client
		post: '/models/' , self model , ':generateContent'
		withEntity: self buildEntity
]

{ #category : #'as yet unclassified' }
GtGeminiGenerateContentsAPIClient >> serializationClass [
	^ GtGeminiGenerationResult
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> tools [
	^ tools
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> tools: anObject [
	tools := anObject
]
