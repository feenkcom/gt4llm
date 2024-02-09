Class {
	#name : #Gt4OpenAIExecutionResult,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #accessing }
Gt4OpenAIExecutionResult class >> prefix [
	^ self subclassResponsibility
]

{ #category : #accessing }
Gt4OpenAIExecutionResult >> asString [
	^ self class prefix, '```text
', self content, '
```'
]

{ #category : #accessing }
Gt4OpenAIExecutionResult >> content [
	^ content
]

{ #category : #accessing }
Gt4OpenAIExecutionResult >> content: aString [
	content := aString
]
