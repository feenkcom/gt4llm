Class {
	#name : #GtGeminiGenerateContentsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'messages',
		'model',
		'instructions',
		'tools',
		'format'
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
	^ self messages
		collect: [ :aMessage | 
			{'role' -> aMessage role.
				'parts'
					-> ({{'text' -> aMessage contentText} asDictionary}
							, (aMessage images
									collect: [ :aFile | 
										{'inline_data'
												-> {'mime_type' -> 'image/jpeg'.
														'data' -> aFile} asDictionary} asDictionary ]))} asDictionary ]
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

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> tools [
	^ tools
]

{ #category : #accessing }
GtGeminiGenerateContentsAPIClient >> tools: anObject [
	tools := anObject
]
