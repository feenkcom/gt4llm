Class {
	#name : #GtLMagritteInputModel,
	#superclass : #GtLInputModel,
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLMagritteInputModel >> addContentTo: aDictionary [
	aDictionary at: name put: model asJsonDictionary 
]

{ #category : #printing }
GtLMagritteInputModel >> printOn: aStream [

	super printOn: aStream.
	
	aStream parenthesize: [
		aStream print: model ]
]
