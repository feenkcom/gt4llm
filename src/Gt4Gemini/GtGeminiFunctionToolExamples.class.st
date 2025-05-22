Class {
	#name : #GtGeminiFunctionToolExamples,
	#superclass : #Object,
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiFunctionToolExamples >> geminiFunctionToolFormat [
	<gtExample>
	| functionTool |
	functionTool := GtLlmToolExamples new functionTool.

	self assert: (functionTool functionGemini includesKey: 'strict') not.
	self assert: ((functionTool functionGemini at: 'parameters' )includesKey: 'additionalProperties') not.

	^ functionTool
]
