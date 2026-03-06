Class {
	#name : #GtLExampleRunDummyExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> errorExample [
	<gtExample>
	<noTest>
	self error: 'Intentional example error'.
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> failingExample [
	<gtExample>
	<noTest>
	self assert: false.
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> regularMethod [
	^ 7
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> successfulExample [
	<gtExample>
	<noTest>
	^ 42
]
