Class {
	#name : #GtGeminiModel,
	#superclass : #GtLlmEntity,
	#instVars : [
		'name',
		'displayName',
		'version',
		'description',
		'inputTokenLimit',
		'outputTokenLimit',
		'supportedGenerationMethods'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiModel class >> serializationProperties [
	^ {#name -> #name.
		#displayName -> #displayName.
		#version -> #version.
		#description -> #description.
		#inputTokenLimit -> #inputTokenLimit.
		#outputTokenLimit -> #outputTokenLimit.
		#supportedGenerationMethods -> #supportedGenerationMethods}
]

{ #category : #accessing }
GtGeminiModel >> description [
	^ description
]

{ #category : #accessing }
GtGeminiModel >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtGeminiModel >> displayName [
	^ displayName
]

{ #category : #accessing }
GtGeminiModel >> displayName: anObject [
	displayName := anObject
]

{ #category : #accessing }
GtGeminiModel >> inputTokenLimit [
	^ inputTokenLimit
]

{ #category : #accessing }
GtGeminiModel >> inputTokenLimit: anObject [
	inputTokenLimit := anObject
]

{ #category : #accessing }
GtGeminiModel >> name [
	^ name
]

{ #category : #accessing }
GtGeminiModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtGeminiModel >> outputTokenLimit [
	^ outputTokenLimit
]

{ #category : #accessing }
GtGeminiModel >> outputTokenLimit: anObject [
	outputTokenLimit := anObject
]

{ #category : #accessing }
GtGeminiModel >> supportedGenerationMethods [
	^ supportedGenerationMethods
]

{ #category : #accessing }
GtGeminiModel >> supportedGenerationMethods: anObject [
	supportedGenerationMethods := anObject
]

{ #category : #accessing }
GtGeminiModel >> version [
	^ version
]

{ #category : #accessing }
GtGeminiModel >> version: anObject [
	version := anObject
]
