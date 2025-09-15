Class {
	#name : #GtLlmTool,
	#superclass : #GtLlmEntity,
	#instVars : [
		'type',
		'name'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmTool class >> leJsonV4Name [

	^ #gtLlmTool
]

{ #category : #accessing }
GtLlmTool class >> serializationProperties [
	^ {#type -> #type}
]

{ #category : #visiting }
GtLlmTool >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmTool: self
]

{ #category : #'as yet unclassified' }
GtLlmTool >> defaultType [
	^ ''
]

{ #category : #'as yet unclassified' }
GtLlmTool >> description [
	^ ''
]

{ #category : #'as yet unclassified' }
GtLlmTool >> functionAnthropic [
	^ {'type' -> type.
		'name' -> self name} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmTool >> functionResponse [
	^ {'type' -> type} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmTool >> initialize [
	super initialize.
	
	self type: self defaultType
]

{ #category : #accessing }
GtLlmTool >> name [
	^ name ifNil: [ type ]
]

{ #category : #accessing }
GtLlmTool >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTool >> parameters [
	^ {}
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
