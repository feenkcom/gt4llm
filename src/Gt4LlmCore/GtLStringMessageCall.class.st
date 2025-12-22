Class {
	#name : #GtLStringMessageCall,
	#superclass : #GtLMessageCall,
	#instVars : [
		'string'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #serialization }
GtLStringMessageCall >> serialize [
	^ string
]

{ #category : #accessing }
GtLStringMessageCall >> string: aString [
	string := aString
]
