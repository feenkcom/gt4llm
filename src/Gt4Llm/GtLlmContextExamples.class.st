Class {
	#name : #GtLlmContextExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmContextExamples >> blockFromString: aString [ 
	^ (LeParser parse: aString) parts first
]

{ #category : #accessing }
GtLlmContextExamples >> defaultChecker [
	<gtExample>
	| composite |
	composite := GtLlmContext defaultCodeblockPipeline.
	self assert: composite checker children size equals: 3.
	^ composite
]

{ #category : #accessing }
GtLlmContextExamples >> defaultCheckerForPythonOnCorrectCode [
	<gtExample>
	<noTest>
	| checker string result |
	checker := self defaultChecker.
	string := self blockFromString: '```python
42 + 3
```'.
	result := checker check: string.
	self assert: result isError not.
	^ result 
]

{ #category : #accessing }
GtLlmContextExamples >> defaultCheckerForSmalltalkOnCodeWithSyntaxError [
	<gtExample>
	<noTest>
	| checker string result |
	checker := self defaultChecker.
	string := self blockFromString: '```smalltalk
lol:
```'.
	result := checker check: string.
	self assert: result isError.
	^ result 
]

{ #category : #accessing }
GtLlmContextExamples >> defaultCheckerOnCorrectSmalltalkCode [
	<gtExample>
	| checker string result |
	checker := self defaultChecker.
	string := self blockFromString: '```smalltalk
42
```'.
	result := checker check: string.
	self assert: result isError not.
	^ result 
]

{ #category : #accessing }
GtLlmContextExamples >> defaultCheckerOnSmalltalkCodeWithError [
	<gtExample>
	| checker string result |
	checker := self defaultChecker.
	string := self blockFromString: '```smalltalk
42 haba
```'.
	result := checker check: string.
	self assert: result isError.
	^ result 
]
