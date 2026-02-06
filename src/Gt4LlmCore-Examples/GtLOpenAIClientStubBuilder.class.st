Class {
	#name : #GtLOpenAIClientStubBuilder,
	#superclass : #GtLOpenAIClientZincBuilder,
	#instVars : [
		'responses'
	],
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'api - instantiation' }
GtLOpenAIClientStubBuilder >> create [
	"Create a new Zinc client to communicate with OpenAI server"

	| aClient |
	aClient := GtLOpenAIClientStub new responses: responses.
	^ aClient
]

{ #category : #accessing }
GtLOpenAIClientStubBuilder >> responses [
	^ responses
]

{ #category : #accessing }
GtLOpenAIClientStubBuilder >> responses: aCollectionOfZnResponses [
	responses := aCollectionOfZnResponses
]
