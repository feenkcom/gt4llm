Class {
	#name : #GtMagriteJSONDataCreationVisitor,
	#superclass : #MAVisitor,
	#instVars : [
		'currentObject',
		'jsonResult'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtMagriteJSONDataCreationVisitor >> currentObject [
	"we have this state because magritte does not return the value of the accepting a visitor"
	^ currentObject
]

{ #category : #accessing }
GtMagriteJSONDataCreationVisitor >> currentObject: anObject [
	currentObject := anObject
]

{ #category : #accessing }
GtMagriteJSONDataCreationVisitor >> jsonResult [
	^ jsonResult
]

{ #category : #accessing }
GtMagriteJSONDataCreationVisitor >> jsonResult: anObject [
	jsonResult := anObject
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitBooleanDescription: aStringDescription [
	^ jsonResult := self currentObject perform: aStringDescription accessor readSelector.
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitDateAndTimeDescription: aDateTimeDescription [
	^ jsonResult := (self currentObject 
			perform: aDateTimeDescription accessor readSelector) 
				ifNotNil: [ :aDateAndTime |
					aDateAndTime asIso8601 ].
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitNumberDescription: aStringDescription [
	^ jsonResult := self currentObject perform: aStringDescription accessor readSelector.
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitPriorityContainer: aContainer [
	"The properties are keyed by the names of the accessors, as Strings (JSON keys)"
	jsonResult := NeoJSONObject new.
	(aContainer children
		sorted: [ :aDescription | aDescription accessor readSelector] ascending)
		do: [ :aDescription | 
			| propertyValue visitor |
			propertyValue := self currentObject
					perform: aDescription accessor readSelector.
			visitor := GtMagriteJSONDataCreationVisitor new currentObject: self currentObject.
			aDescription acceptMagritte: visitor.
			jsonResult at: aDescription accessor readSelector asString put: visitor jsonResult ].
	^ jsonResult
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitStringDescription: aStringDescription [
	"JSON strings are Strings (a Symbol value, such as a class name, is converted)"

	| aValue |
	aValue := self currentObject perform: aStringDescription accessor readSelector.
	^ jsonResult := aValue isSymbol ifTrue: [ aValue asString ] ifFalse: [ aValue ]
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitToManyRelationDescription: aDescription [
	| result all |
	result := self currentObject perform: aDescription accessor readSelector.
	all := result
			collect: [ :each | 
				| visitor |
				visitor := GtMagriteJSONDataCreationVisitor new currentObject: each.
				each magritteDescription acceptMagritte: visitor.
				visitor jsonResult ].

	^ jsonResult := NeoJSONArray withAll: all
]

{ #category : #visiting }
GtMagriteJSONDataCreationVisitor >> visitToManyScalarRelationDescription: aDescription [
	"JSON strings are Strings (Symbol elements, such as class names, are converted)"

	| result |
	result := self currentObject perform: aDescription accessor readSelector.
	^ jsonResult := NeoJSONArray withAll: (result collect: [ :each | each isSymbol ifTrue: [ each asString ] ifFalse: [ each ] ])
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitToOneRelationDescription: aDescription [
	<gsCode: '	| result visitor |
	result := self currentObject perform: aDescription accessor readSelector.
	result ifNil: [ ^ jsonResult := nil ].
	visitor := GtMagriteJSONDataCreationVisitor new currentObject: result.
	result magritteDescription acceptMagritte: visitor.
	^ jsonResult := visitor jsonResult'>
	| result visitor |
	result := self currentObject perform: aDescription accessor readSelector.
	visitor := GtMagriteJSONDataCreationVisitor new currentObject: result.
	result magritteDescription acceptMagritte: visitor.
	^ jsonResult := visitor jsonResult
]
