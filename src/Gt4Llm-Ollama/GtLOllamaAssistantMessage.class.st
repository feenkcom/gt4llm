Class {
	#name : #GtLOllamaAssistantMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'responseModels',
		'modelName',
		'rawData',
		'requestResponse',
		'hasCompactionResponse'
	],
	#category : #'Gt4Llm-Ollama-Model'
}

{ #category : #accessing }
GtLOllamaAssistantMessage >> contentOneLineSummary [
	<return: #String>
	^ self contentText copyReplaceAll: String lf with: String space
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> contentText [
	^ (self rawData at: 'message' ifAbsent: [ Dictionary new ])
		at: 'content'
		ifAbsent: [ '' ]
]

{ #category : #testing }
GtLOllamaAssistantMessage >> hasCompactionResponse [
	^ hasCompactionResponse ifNil: [ false ]
]

{ #category : #testing }
GtLOllamaAssistantMessage >> hasResponse [
	^ self contentText isNotEmpty
]

{ #category : #initialization }
GtLOllamaAssistantMessage >> initializeFromResult: aResult [
	self
		requestResponse: aResult requestResponse;
		rawData: aResult rawData;
		modelName: aResult model
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> markWithCompactionResponse [
	hasCompactionResponse := true
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> modelName: anObject [
	modelName := anObject
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> role [
	^ 'assistant'
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> senderText [
	^ modelName ifNil: [ 'Assistant' ] ifNotNil: [ modelName ]
]
