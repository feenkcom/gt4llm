Class {
	#name : #GtLOpenAIDeleteFileAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIDeleteFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIDeleteFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAIDeleteFileAPIClient >> request [
	^ self client
		delete: 'files/', file
]

{ #category : #accessing }
GtLOpenAIDeleteFileAPIClient >> serializationClass [
	^ GtLOpenAIDeletion
]
