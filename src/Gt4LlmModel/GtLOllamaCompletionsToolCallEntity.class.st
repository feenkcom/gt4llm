"
Represents a tool call entry from an Ollama-compatible completions response backed by raw JSON data.
"
Class {
	#name : #GtLOllamaCompletionsToolCallEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOllamaCompletionsToolCallEntity >> function [
	^ GtLFunctionCallEntity rawData: (self rawData at: 'function')
]

{ #category : #accessing }
GtLOllamaCompletionsToolCallEntity >> id [
	^ self rawData at: 'id'
]

{ #category : #accessing }
GtLOllamaCompletionsToolCallEntity >> index [
	^ self rawData at: 'index'
]

{ #category : #accessing }
GtLOllamaCompletionsToolCallEntity >> type [
	^ self rawData at: 'type'
]
