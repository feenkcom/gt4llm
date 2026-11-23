"
I represent the class variables of a class.
"
Class {
	#name : #GtLClassVariableType,
	#superclass : #GtLVariableType,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLClassVariableType class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
GtLClassVariableType >> declaredNamesIn: aClassDefinitionDescription [
	^ aClassDefinitionDescription classVariableNames
]

{ #category : #accessing }
GtLClassVariableType >> label [
	^ 'Class variable'
]
