"
Represents an OpenAI-compatible message payload backed by raw JSON data.
"
Class {
	#name : #GtLOpenAiMessagesEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiMessagesEntity >> content [
	^ (self rawData at: 'content') collect: [ :each | GtLOpenAiContentEntity new rawData: each ]
]

{ #category : #accessing }
GtLOpenAiMessagesEntity >> role [
	^ self rawData at: 'role'
]
