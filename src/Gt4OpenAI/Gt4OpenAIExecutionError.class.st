Class {
	#name : #Gt4OpenAIExecutionError,
	#superclass : #Gt4OpenAIExecutionResult,
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #accessing }
Gt4OpenAIExecutionError >> prefix [
	^ 'LAST SCRIPT ERROR: '
]
