"
I represent the class-side slots of a class.
"
Class {
	#name : #GtLClassSlotType,
	#superclass : #GtLVariableType,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLClassSlotType class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
GtLClassSlotType >> declaredNamesIn: aClassDefinitionDescription [
	^ aClassDefinitionDescription classSlotNames
]

{ #category : #accessing }
GtLClassSlotType >> label [
	^ 'Class slot'
]
