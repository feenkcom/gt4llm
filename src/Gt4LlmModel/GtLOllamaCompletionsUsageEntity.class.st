"
Represents usage information from an Ollama-compatible completions response backed by raw JSON data.
"
Class {
	#name : #GtLOllamaCompletionsUsageEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOllamaCompletionsUsageEntity >> completionTokens [
	^ self rawData at: 'completion_tokens'
]

{ #category : #accessing }
GtLOllamaCompletionsUsageEntity >> promptTokens [
	^ self rawData at: 'prompt_tokens'
]

{ #category : #accessing }
GtLOllamaCompletionsUsageEntity >> totalTokens [
	^ self rawData at: 'total_tokens'
]
