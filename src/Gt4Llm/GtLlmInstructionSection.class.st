Class {
	#name : #GtLlmInstructionSection,
	#superclass : #GtLlmInstruction,
	#instVars : [
		'title',
		'body'
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
GtLlmInstructionSection >> instructionString [
	^ '# ' , self title
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
