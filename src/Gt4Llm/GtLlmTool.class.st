Class {
	#name : #GtLlmTool,
	#superclass : #GtLlmEntity,
	#instVars : [
		'type'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmTool class >> serializationProperties [
	^ {#type -> #type}
]

{ #category : #'as yet unclassified' }
GtLlmTool >> defaultType [
	^ ''
]

{ #category : #'as yet unclassified' }
GtLlmTool >> initialize [
	super initialize.
	
	self type: self defaultType
]

{ #category : #accessing }
GtLlmTool >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self type;
		nextPut: $)
]

{ #category : #accessing }
GtLlmTool >> type [
	^ type
]

{ #category : #accessing }
GtLlmTool >> type: anObject [
	type := anObject
]
