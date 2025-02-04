Class {
	#name : #GtLlmInstructionList,
	#superclass : #GtLlmInstructionComponent,
	#instVars : [
		'items'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstructionList >> addItem: anItem [
	items add: (anItem asInstruction parent: self)
]

{ #category : #accessing }
GtLlmInstructionList >> children [
	^ items
]

{ #category : #accessing }
GtLlmInstructionList >> gtDisplayOn: stream [
	stream nextPutAll: '--List--'
]

{ #category : #accessing }
GtLlmInstructionList >> initialize [
	super initialize.
	
	items := OrderedCollection new
]

{ #category : #accessing }
GtLlmInstructionList >> instructionString [
	^ Character cr
		join: (self items collect: [ :anItem | '- ' , anItem instructionString ])
]

{ #category : #accessing }
GtLlmInstructionList >> items [
	^ items
]

{ #category : #accessing }
GtLlmInstructionList >> items: anObject [
	items := anObject collect: #asInstruction
]
