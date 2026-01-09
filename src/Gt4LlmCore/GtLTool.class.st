Class {
	#name : #GtLTool,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLTool class >> leJsonV4AttributeMapping [
	^ {}
]

{ #category : #accessing }
GtLTool class >> leJsonV4Name [

	^ #gtLTool
]

{ #category : #accessing }
GtLTool class >> serializationProperties [
	^ {#type -> #type}
]

{ #category : #visiting }
GtLTool >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmTool: self
]

{ #category : #'as yet unclassified' }
GtLTool >> functionAnthropic [
	^ {'type' -> self type.
		'name' -> self name} asDictionary
]

{ #category : #'as yet unclassified' }
GtLTool >> functionResponse [
	^ {'type' -> self type} asDictionary
]

{ #category : #'as yet unclassified' }
GtLTool >> name [
	self subclassResponsibility
]

{ #category : #accessing }
GtLTool >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self type;
		nextPut: $)
]

{ #category : #accessing }
GtLTool >> type [
	^ ''
]
