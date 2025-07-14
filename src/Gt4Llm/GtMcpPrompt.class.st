Class {
	#name : #GtMcpPrompt,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'arguments',
		'promptBlock'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtMcpPrompt >> arguments [
	^ arguments
]

{ #category : #accessing }
GtMcpPrompt >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
GtMcpPrompt >> callWith: args [
	^ promptBlock value: args
]

{ #category : #accessing }
GtMcpPrompt >> description [
	^ description
]

{ #category : #accessing }
GtMcpPrompt >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtMcpPrompt >> name [
	^ name
]

{ #category : #accessing }
GtMcpPrompt >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtMcpPrompt >> promptBlock [
	^ promptBlock
]

{ #category : #accessing }
GtMcpPrompt >> promptBlock: anObject [
	promptBlock := anObject
]
