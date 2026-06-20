"
Represents an OpenAI-compatible content payload backed by raw JSON data.
"
Class {
	#name : #GtLOpenAiContentEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiContentEntity >> text [
	^ self rawData at: 'text'
]

{ #category : #accessing }
GtLOpenAiContentEntity >> type [
	^ self rawData at: 'type'
]
