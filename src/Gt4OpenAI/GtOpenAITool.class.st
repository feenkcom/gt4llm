Class {
	#name : #GtOpenAITool,
	#superclass : #GtLlmEntity,
	#instVars : [
		'type'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAITool class >> serializationProperties [
	^ {#type -> #type}
]

{ #category : #accessing }
GtOpenAITool >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self type;
		nextPut: $)
]

{ #category : #accessing }
GtOpenAITool >> type [
	^ type
]

{ #category : #accessing }
GtOpenAITool >> type: anObject [
	type := anObject
]
