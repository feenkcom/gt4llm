"
Examples for GtLExampleReference equality and hashing.
"
Class {
	#name : #GtLExampleReferenceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLExampleReferenceExamples >> differentReferences [
	<gtExample>
	| first second |
	first := GtLExampleReference new
		exampleClassName: 'GtLMessageSummarizerExamples';
		methodName: 'exampleStatusSuccess';
		classSide: false.
	second := GtLExampleReference new
		exampleClassName: 'GtLMessageSummarizerExamples';
		methodName: 'messagesGroupWithToolAndExampleSummaries';
		classSide: false.

	self assert: first ~= second.
	^ first
]

{ #category : #examples }
GtLExampleReferenceExamples >> equalReferences [
	<gtExample>
	| first second |
	first := GtLExampleReference new
		exampleClassName: 'GtLMessageSummarizerExamples';
		methodName: 'exampleStatusSuccess';
		classSide: false.
	second := GtLExampleReference new
		exampleClassName: 'GtLMessageSummarizerExamples';
		methodName: 'exampleStatusSuccess';
		classSide: false.

	self assert: first equals: second.
	self assert: first hash equals: second hash.
	^ first
]
