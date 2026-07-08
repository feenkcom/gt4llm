"
Represents an OpenAI-compatible tool description backed by raw JSON data.
"
Class {
	#name : #GtLOpenAiToolEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiToolEntity >> description [

	^ self rawData at: 'description'
]

{ #category : #accessing }
GtLOpenAiToolEntity >> function [
	^ self rawData at: 'function'
]

{ #category : #accessing }
GtLOpenAiToolEntity >> name [

	^ self rawData at: 'name'
]

{ #category : #accessing }
GtLOpenAiToolEntity >> parameters [

	^ self rawData at: 'parameters'
]

{ #category : #accessing }
GtLOpenAiToolEntity >> type [
	^ self rawData at: 'type'
]
