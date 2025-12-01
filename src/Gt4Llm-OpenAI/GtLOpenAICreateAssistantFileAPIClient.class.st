Class {
	#name : #GtLOpenAICreateAssistantFileAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'file',
		'assistant'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPIClient >> makeRequest [
	^ self client
		post: 'assistants/' , self assistant , '/files'
		withEntity: {'file_id' -> self file} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPIClient >> request [
	"the file API fails the first time certain (seemingly larger) files are being associated with assistants; retry once if it happens"
	^ [ self makeRequest ]
		on: GtLOpenAIError
		do: [ self makeRequest ]
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPIClient >> serializationClass [
	^ GtLOpenAIAssistantFile
]
