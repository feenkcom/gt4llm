Class {
	#name : #GtLMcpPrompt,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'arguments',
		'promptBlock'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #accessing }
GtLMcpPrompt >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLMcpPrompt >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
GtLMcpPrompt >> callWith: args [
	^ promptBlock value: args
]

{ #category : #accessing }
GtLMcpPrompt >> description [
	^ description
]

{ #category : #accessing }
GtLMcpPrompt >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLMcpPrompt >> name [
	^ name
]

{ #category : #accessing }
GtLMcpPrompt >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLMcpPrompt >> promptBlock [
	^ promptBlock
]

{ #category : #accessing }
GtLMcpPrompt >> promptBlock: anObject [
	promptBlock := anObject
]
