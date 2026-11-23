"
I represent the instance slots of a class.
"
Class {
	#name : #GtLInstanceSlotType,
	#superclass : #GtLVariableType,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLInstanceSlotType class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
GtLInstanceSlotType >> declaredNamesIn: aClassDefinitionDescription [
	^ aClassDefinitionDescription instanceSlotNames
]

{ #category : #accessing }
GtLInstanceSlotType >> label [
	^ 'Instance slot'
]
