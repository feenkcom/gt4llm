"
Represents a choice entry from an Ollama-compatible completions response backed by raw JSON data.
"
Class {
	#name : #GtLOllamaCompletionsChoiceEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOllamaCompletionsChoiceEntity >> finishReason [
	^ self rawData at: 'finish_reason'
]

{ #category : #accessing }
GtLOllamaCompletionsChoiceEntity >> index [
	^ self rawData at: 'index'
]

{ #category : #accessing }
GtLOllamaCompletionsChoiceEntity >> message [
	^ GtLOllamaCompletionsMessageEntity new rawData: (self rawData at: 'message')
]
