Class {
	#name : #Gt4OpenAITool,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'type'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAITool class >> serializationProperties [
	^ {#type -> #type}
]

{ #category : #accessing }
Gt4OpenAITool >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self type;
		nextPut: $)
]

{ #category : #accessing }
Gt4OpenAITool >> type [
	^ type
]

{ #category : #accessing }
Gt4OpenAITool >> type: anObject [
	type := anObject
]