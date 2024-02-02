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
Gt4OpenAICreateAssistantFileAPIClient >> request [
	^ self client
		post: 'assistants/' , self assistant , '/files'
		withEntity: {'file_id' -> self file} asDictionary
]

{ #category : #accessing }
Gt4OpenAICreateAssistantFileAPIClient >> serializationClass [
	^ Gt4OpenAIAssistantFile
]
