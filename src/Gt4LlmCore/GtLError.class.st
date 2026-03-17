Class {
	#name : #GtLError,
	#superclass : #Error,
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtLError class >> from: aMessage [
	^ self new messageText: aMessage
]

{ #category : #views }
GtLError >> gtMessageTextFor: aView [
	<gtView>
	<gtExceptionDebuggingView>
	^ super gtMessageTextFor: aView
]
