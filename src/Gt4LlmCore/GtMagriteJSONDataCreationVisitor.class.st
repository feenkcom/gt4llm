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
GtMagriteJSONDataCreationVisitor >> visitNumberDescription: aStringDescription [
	^ jsonResult := self currentObject perform: aStringDescription accessor readSelector.
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitPriorityContainer: aContainer [
	jsonResult := NeoJSONObject new.
	aContainer children
		do: [ :aDescription | 
			| propertyValue visitor |
			propertyValue := self currentObject
					perform: aDescription accessor readSelector.
			visitor := GtMagriteJSONDataCreationVisitor new currentObject: self currentObject.
			aDescription acceptMagritte: visitor.
			jsonResult at: aDescription accessor readSelector put: visitor jsonResult.
			 ].
	^ jsonResult
]

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitStringDescription: aStringDescription [
	^ jsonResult := self currentObject perform: aStringDescription accessor readSelector.
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

{ #category : #'visiting-description' }
GtMagriteJSONDataCreationVisitor >> visitToOneRelationDescription: aDescription [
	| result visitor |
	result := self currentObject perform: aDescription accessor readSelector.
	visitor := GtMagriteJSONDataCreationVisitor new currentObject: result.
	result magritteDescription acceptMagritte: visitor.
	^ jsonResult := visitor jsonResult
]
