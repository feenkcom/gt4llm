Class {
	#name : #GtLOllamaProviderProcessedMessage,
	#superclass : #Object,
	#instVars : [
		'result',
		'inputMessage',
		'outputMessage',
		'anotherProcessedMessage'
	],
	#category : 'Gt4Llm-Ollama-Model'
}

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> allToolCalls [
	^ Array
		streamContents: [ :aStream | self processedMessagesDo: [ :aMessage | aStream nextPutAll: aMessage toolCalls ] ]
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> anotherProcessedMessage [
	^ anotherProcessedMessage
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> anotherProcessedMessage: anObject [
	anotherProcessedMessage := anObject
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> finalMessage [
	self
		processedMessagesDo: [ :eachMessage | eachMessage outputMessage ifNotNil: [ :anOutputMessage | ^ anOutputMessage ] ].

	^ nil
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> inputMessage [
	^ inputMessage
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> inputMessage: anObject [
	inputMessage := anObject
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> outputMessage [
	^ outputMessage
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> outputMessage: anObject [
	outputMessage := anObject
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> processedMessagesDo: aBlock [
	aBlock cull: self.
	self anotherProcessedMessage
		ifNotNil: [ :aMessage | aMessage processedMessagesDo: aBlock ]
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> result [
	^ result
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtLOllamaProviderProcessedMessage >> toolCalls [
	^ self result ifNotNil: #toolCalls ifNil: [ #() ]
]
