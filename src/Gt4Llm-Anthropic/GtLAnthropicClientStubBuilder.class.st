Class {
	#name : #GtLAnthropicClientStubBuilder,
	#superclass : #GtLAnthropicClientZincBuilder,
	#instVars : [
		'responses'
	],
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #'as yet unclassified' }
GtLAnthropicClientStubBuilder >> newBasicClient [
	^ GtLOpenAIClientStub new responses: responses
]

{ #category : #accessing }
GtLAnthropicClientStubBuilder >> responses [
	^ responses
]

{ #category : #accessing }
GtLAnthropicClientStubBuilder >> responses: anObject [
	responses := anObject
]
