Class {
	#name : #Gt4OpenAICreateAssistantFileAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'file',
		'assistant'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> makeRequest [
	^ self client
		post: 'assistants/' , self assistant , '/files'
		withEntity: {'file_id' -> self file} asDictionary
]

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> request [
	"the file API fails the first time certain (seemingly larger) files are being associated with assistants; retry once if it happens"
	^ [ self makeRequest ]
		on: Gt4OpenAIError
		do: [ self makeRequest ]
]

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> serializationClass [
	^ Gt4OpenAIAssistantFile
]
