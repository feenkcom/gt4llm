Class {
	#name : #GtLOpenAIDeleteFileAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIDeleteFileAPICommand >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIDeleteFileAPICommand >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAIDeleteFileAPICommand >> request [
	^ self client
		delete: 'files/', file
]

{ #category : #accessing }
GtLOpenAIDeleteFileAPICommand >> serializationClass [
	^ GtLOpenAIDeletion
]
