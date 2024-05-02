Class {
	#name : #GtLlmInstructionSection,
	#superclass : #GtLlmInstruction,
	#instVars : [
		'title',
		'body',
		'headerLevel'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstructionSection >> body [
	^ body
]

{ #category : #accessing }
GtLlmInstructionSection >> body: anObject [
	body := anObject
]

{ #category : #accessing }
GtLlmInstructionSection >> headerLevel [
	^ headerLevel
]

{ #category : #accessing }
GtLlmInstructionSection >> headerLevel: anObject [
	self assert: anObject > 0.
	headerLevel := anObject
]

{ #category : #accessing }
GtLlmInstructionSection >> initialize [
	super initialize.
	
	headerLevel := 1
]

{ #category : #accessing }
GtLlmInstructionSection >> instructionString [
	^ ('#' repeat: self headerLevel) , ' ' , self title
		, '
	
' , self body instructionString
]

{ #category : #accessing }
GtLlmInstructionSection >> title [
	^ title
]

{ #category : #accessing }
GtLlmInstructionSection >> title: anObject [
	title := anObject
]
