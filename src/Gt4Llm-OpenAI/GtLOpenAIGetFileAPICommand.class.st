Class {
	#name : #GtLOpenAIGetFileAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFileAPICommand >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIGetFileAPICommand >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAIGetFileAPICommand >> request [
	^ self client get: '/files/', self file
]

{ #category : #accessing }
GtLOpenAIGetFileAPICommand >> serializationClass [
	^ GtLOpenAIFile
]
