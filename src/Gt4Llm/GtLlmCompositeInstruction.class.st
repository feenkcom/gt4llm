Class {
	#name : #GtLlmCompositeInstruction,
	#superclass : #GtLlmInstruction,
	#instVars : [
		'items'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmCompositeInstruction >> addItem: anItem [
	items add: (anItem parent: self)
]

{ #category : #accessing }
GtLlmCompositeInstruction >> children [
	^ items
]

{ #category : #accessing }
GtLlmCompositeInstruction >> initialize [
	super initialize.
	
	items := OrderedCollection new
]

{ #category : #accessing }
GtLlmCompositeInstruction >> instructionString [
	^ {Character cr.
		Character cr} join: (items collect: #instructionString)
]
