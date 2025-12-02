Class {
	#name : #GtLOpenAICreateAssistantFileAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'file',
		'assistant'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPICommand >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPICommand >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPICommand >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPICommand >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPICommand >> makeRequest [
	^ self client
		post: 'assistants/' , self assistant , '/files'
		withEntity: {'file_id' -> self file} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPICommand >> request [
	"the file API fails the first time certain (seemingly larger) files are being associated with assistants; retry once if it happens"
	^ [ self makeRequest ]
		on: GtLOpenAIError
		do: [ self makeRequest ]
]

{ #category : #accessing }
GtLOpenAICreateAssistantFileAPICommand >> serializationClass [
	^ GtLOpenAIAssistantFile
]
