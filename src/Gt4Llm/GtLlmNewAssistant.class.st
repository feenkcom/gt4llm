Class {
	#name : #GtLlmNewAssistant,
	#superclass : #Object,
	#instVars : [
		'instruction',
		'connection'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmNewAssistant >> recomputeFormats [
	instruction replaceComponents: self collectFormats
]

{ #category : #'as yet unclassified' }
GtLlmNewAssistant >> textFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Text';
		priority: 2;
		format: 'Text';
		example: '```text
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted,  and code sections using three backticks may be used.

# Headings exist as well
```'
]

{ #category : #'as yet unclassified' }
GtLlmNewAssistant >> treatProvider: aProvider [
	aProvider 
		instructions: instruction asInstructionPiece instructionString;
		format: instruction asJsonSchema;
		tools: self collectTools
]
