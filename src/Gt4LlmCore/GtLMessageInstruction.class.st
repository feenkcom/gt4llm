Class {
	#name : #GtLMessageInstruction,
	#superclass : #Object,
	#instVars : [
		'sections',
		'rootSection'
	],
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLMessageInstruction >> addSection: aSection [
	rootSection sections add: aSection
]

{ #category : #initialization }
GtLMessageInstruction >> asJsonString [
	^ rootSection instructionString
]

{ #category : #initialization }
GtLMessageInstruction >> initialize [
	super initialize.
	
	rootSection := GtLlmInstructionWithSections new
		source: self;
		introduction: 'Input descriptions';
		sections: OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtLMessageInstruction >> rootSection [
	^ rootSection
]
