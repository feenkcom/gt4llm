Class {
	#name : #GtLMessageInstruction,
	#superclass : #Object,
	#instVars : [
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

{ #category : #views }
GtLMessageInstruction >> gtRootSectionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		object: [ rootSection ];
		view: #gtInstructionFor:
]

{ #category : #initialization }
GtLMessageInstruction >> initialize [
	super initialize.
	
	rootSection := GtLlmInstructionWithSections new
		source: self;
		introduction: (GtLlmInstructionString new string: 'Input descriptions')
]

{ #category : #'as yet unclassified' }
GtLMessageInstruction >> rootSection [
	^ rootSection
]
