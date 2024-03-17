Class {
	#name : #GtLlmCompositeCheckerExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmCompositeCheckerExamples >> defaultCheckerForSmalltalk [
	<gtExample>
	| composite |
	composite := GtLlmCompositeChecker defaultSmalltalkChecker.
	self assert: composite checkers size = 2.
	^ composite
]

{ #category : #accessing }
GtLlmCompositeCheckerExamples >> defaultCheckerForSmalltalkOnCodeWithError [
	<gtExample>
	| checker string result |
	checker := self defaultCheckerForSmalltalk.
	string := '42'.
	result := checker check: string.
	self assert: result hasErrors not.
	^ result 
]

{ #category : #accessing }
GtLlmCompositeCheckerExamples >> defaultCheckerForSmalltalkOnCodeWithSyntaxError [
	<gtExample>
	| checker string result |
	checker := self defaultCheckerForSmalltalk.
	string := '42 / 0'.
	result := checker check: string.
	self assert: result hasErrors.
	^ result 
]

{ #category : #accessing }
GtLlmCompositeCheckerExamples >> defaultCheckerForSmalltalkOnCorrectCode [
	<gtExample>
	| checker string result |
	checker := self defaultCheckerForSmalltalk.
	string := '42'.
	result := checker check: string.
	self assert: result hasErrors not.
	^ result 
]
