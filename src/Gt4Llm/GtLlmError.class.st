Class {
	#name : #GtLlmError,
	#superclass : #Error,
	#category : #Gt4Llm
}

{ #category : #'instance creation' }
GtLlmError class >> from: aMessage [
	^ self new messageText: aMessage
]

{ #category : #views }
GtLlmError >> gtMessageTextFor: aView [
	<gtView>
	<gtExceptionDebuggingView>
	^ super gtMessageTextFor: aView
]
