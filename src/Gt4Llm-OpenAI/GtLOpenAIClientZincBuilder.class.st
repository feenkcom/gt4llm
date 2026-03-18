Class {
	#name : #GtLOpenAIClientZincBuilder,
	#superclass : #Object,
	#instVars : [
		'apiKey'
	],
	#category : 'Gt4Llm-OpenAI-Client'
}

{ #category : #accessing }
GtLOpenAIClientZincBuilder >> apiKey [
	^ apiKey
]

{ #category : #'api - initialization' }
GtLOpenAIClientZincBuilder >> apiKey: anObject [
	apiKey := anObject
]

{ #category : #'api - instantiation' }
GtLOpenAIClientZincBuilder >> create [
	"Create a new Zinc client to communicate with OpenAI server"

	| aClient |
	aClient := self newBasicClient.
	aClient forJsonREST.
	aClient headerAt: 'OpenAI-Beta' put: 'assistants=v2'.
	aClient timeout: 1200.
	aClient setBearerAuthentication: apiKey.
	^ aClient
]

{ #category : #'private - instance creation' }
GtLOpenAIClientZincBuilder >> newBasicClient [
	^ ZnClient new
]
