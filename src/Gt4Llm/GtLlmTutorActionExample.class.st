Class {
	#name : #GtLlmTutorActionExample,
	#superclass : #Object,
	#instVars : [
		'instruction',
		'input',
		'output'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorActionExample >> asInstruction [
	^ ('PROMPT:
' , self instruction
		, '

state:
' , self input
		, '

OUTPUT:
' , self output) asInstruction
]

{ #category : #accessing }
GtLlmTutorActionExample >> input [
	^ input
]

{ #category : #accessing }
GtLlmTutorActionExample >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> instruction [
	^ instruction
]

{ #category : #accessing }
GtLlmTutorActionExample >> instruction: anObject [
	instruction := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> output [
	^ output
]

{ #category : #accessing }
GtLlmTutorActionExample >> output: anObject [
	output := anObject
]
