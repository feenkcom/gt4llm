Class {
	#name : #Gt4OpenAIExecutionResult,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #accessing }
Gt4OpenAIExecutionResult >> asString [
	^ self prefix, self content
]

{ #category : #accessing }
Gt4OpenAIExecutionResult >> content [
	^ content
]

{ #category : #accessing }
Gt4OpenAIExecutionResult >> content: aString [
	content := aString
]

{ #category : #accessing }
Gt4OpenAIExecutionResult >> prefix [
	^ self subclassResponsibility
]
