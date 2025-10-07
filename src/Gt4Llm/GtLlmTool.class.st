Class {
	#name : #GtLlmTool,
	#superclass : #GtLlmEntity,
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
GtLlmTool >> description [
	^ ''
]

{ #category : #'as yet unclassified' }
GtLlmTool >> functionAnthropic [
	^ {'type' -> self type.
		'name' -> self name} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmTool >> functionResponse [
	^ {'type' -> self type} asDictionary
]

{ #category : #accessing }
GtLlmTool >> name [
	^ ''
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
	^ ''
]
