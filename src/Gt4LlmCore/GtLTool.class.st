Class {
	#name : #GtLTool,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLTool class >> isAbstract [
	^ self name = #GtLTool
]

{ #category : #accessing }
GtLTool class >> serializationProperties [
	^ {#type -> #type}
]

{ #category : #visiting }
GtLTool >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmTool: self
]

{ #category : #'api - responses' }
GtLTool >> functionAnthropic [
	^ {'type' -> self type.
		'name' -> self name} asDictionary
]

{ #category : #'api - responses' }
GtLTool >> functionOpenAI [
	^ {'type' -> self type} asDictionary
]

{ #category : #accessing }
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
