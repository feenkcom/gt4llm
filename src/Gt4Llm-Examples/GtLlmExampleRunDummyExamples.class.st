Class {
	#name : #GtLlmExampleRunDummyExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmExampleRunDummyExamples >> errorExample [
	<gtExample>
	<noTest>
	self error: 'Intentional example error'.
]

{ #category : #'llm-generated' }
GtLlmExampleRunDummyExamples >> failingExample [
	<gtExample>
	<noTest>
	self assert: false.
]

{ #category : #'llm-generated' }
GtLlmExampleRunDummyExamples >> regularMethod [
	^ 7
]

{ #category : #'llm-generated' }
GtLlmExampleRunDummyExamples >> successfulExample [
	<gtExample>
	<noTest>
	^ 42
]
