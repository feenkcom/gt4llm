Class {
	#name : #GtGeminiGenerateContentsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'messages',
		'model'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiGenerateContentsAPIClient >> buildMessageEntities [
	^ self messages
		collect: [ :aMessage | 
			{'role' -> aMessage role.
				'parts' -> {{'text' -> aMessage contentText} asDictionary}} asDictionary ]
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
	^ self client post: '/models/' , self model , ':generateContent' withEntity: {
		'contents' -> self buildMessageEntities
	} asDictionary
]
