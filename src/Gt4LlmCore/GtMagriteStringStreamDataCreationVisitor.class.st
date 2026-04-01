Class {
	#name : #GtMagriteStringStreamDataCreationVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'currentObject',
		'stringStream',
		'jsonResult'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtMagriteStringStreamDataCreationVisitor >> currentObject [
	"we have this state because magritte does not return the value of the accepting a visitor"
	^ currentObject
]

{ #category : #accessing }
GtMagriteStringStreamDataCreationVisitor >> currentObject: anObject [
	currentObject := anObject
]

{ #category : #accessing }
GtMagriteStringStreamDataCreationVisitor >> stringStream [

	^ stringStream
]

{ #category : #accessing }
GtMagriteStringStreamDataCreationVisitor >> stringStream: anObject [

	stringStream := anObject
]

{ #category : #'visiting-description' }
GtMagriteStringStreamDataCreationVisitor >> visitPriorityContainer: aContainer [
	aContainer children
		do: [ :aDescription | aDescription acceptMagritte: self ]
		separatedBy: [ self stringStream space ]
]

{ #category : #'visiting-description' }
GtMagriteStringStreamDataCreationVisitor >> visitStringDescription: aStringDescription [
	| aString |
	aString := aStringDescription read: self currentObject.

	self stringStream nextPutAll: aString asString
]

{ #category : #'visiting-description' }
GtMagriteStringStreamDataCreationVisitor >> visitToManyRelationDescription: aDescription [
	| result |
	result := aDescription read: self currentObject.
	result
		do: [ :eachObject | 
			| visitor |
			visitor := GtMagriteStringStreamDataCreationVisitor new
					currentObject: eachObject;
					stringStream: self stringStream.
			eachObject magritteDescription acceptMagritte: visitor ]
		separatedBy: [ self stringStream space ]
]

{ #category : #'visiting-description' }
GtMagriteStringStreamDataCreationVisitor >> visitToOneRelationDescription: aDescription [
	| result visitor |
	result := aDescription read: self currentObject.
	visitor := GtMagriteStringStreamDataCreationVisitor new
			currentObject: result;
			stringStream: self stringStream.
	result magritteDescription acceptMagritte: visitor
]
