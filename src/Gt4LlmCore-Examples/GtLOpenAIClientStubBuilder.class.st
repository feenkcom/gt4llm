Class {
	#name : #GtLOpenAIClientStubBuilder,
	#superclass : #GtLOpenAIClientZincBuilder,
	#instVars : [
		'responses'
	],
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'private - instance creation' }
GtLOpenAIClientStubBuilder >> newBasicClient [
	^ GtLOpenAIClientStub new responses: responses
]

{ #category : #accessing }
GtLOpenAIClientStubBuilder >> responses [
	^ responses
]

{ #category : #accessing }
GtLOpenAIClientStubBuilder >> responses: aCollectionOfZnResponses [
	responses := aCollectionOfZnResponses
]
