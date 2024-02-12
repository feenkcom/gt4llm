Class {
	#name : #Gt4OpenAIExecutionError,
	#superclass : #Gt4OpenAIExecutionResult,
	#instVars : [
		'stackString'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #accessing }
Gt4OpenAIExecutionError class >> prefix [
	^ 'LAST SCRIPT ERROR: '
]

{ #category : #accessing }
Gt4OpenAIExecutionError >> contentString [
	^ self stackString
]

{ #category : #accessing }
Gt4OpenAIExecutionError >> stackString [
	^ stackString
]

{ #category : #accessing }
Gt4OpenAIExecutionError >> stackString: anObject [
	stackString := anObject
]
