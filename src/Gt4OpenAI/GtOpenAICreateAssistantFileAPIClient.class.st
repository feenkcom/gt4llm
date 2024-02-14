Class {
	#name : #GtOpenAICreateAssistantFileAPIClient,
	#superclass : #GtOpenAIEndpointClient,
	#instVars : [
		'file',
		'assistant'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAICreateAssistantFileAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtOpenAICreateAssistantFileAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAICreateAssistantFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAICreateAssistantFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtOpenAICreateAssistantFileAPIClient >> makeRequest [
	^ self client
		post: 'assistants/' , self assistant , '/files'
		withEntity: {'file_id' -> self file} asDictionary
]

{ #category : #accessing }
GtOpenAICreateAssistantFileAPIClient >> request [
	"the file API fails the first time certain (seemingly larger) files are being associated with assistants; retry once if it happens"
	^ [ self makeRequest ]
		on: GtOpenAIError
		do: [ self makeRequest ]
]

{ #category : #accessing }
GtOpenAICreateAssistantFileAPIClient >> serializationClass [
	^ GtOpenAIAssistantFile
]
