Class {
	#name : #GtOllamaError,
	#superclass : #Error,
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaError class >> from: aMessage [
	^ self new messageText: aMessage
]

{ #category : #accessing }
GtOllamaError >> gtMessageTextFor: aView [
	<gtExceptionDebuggingView>
	^ super gtMessageTextFor: aView
]
