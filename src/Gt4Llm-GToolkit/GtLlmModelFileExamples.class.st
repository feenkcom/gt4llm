Class {
	#name : #GtLlmModelFileExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #asserting }
GtLlmModelFileExamples >> assert: aBoolean [
	"We check for true explicitly to make the assertion fail for non booleans"
	aBoolean == true ifFalse: [self signalFailure: 'Assertion failed']
			
]

{ #category : #asserting }
GtLlmModelFileExamples >> assert: aBooleanOrBlock description: aStringOrBlock [
	aBooleanOrBlock value ifFalse: [
		| message |
		message := aStringOrBlock value.
		self classForTestResult failure signal: message]
			
]

{ #category : #asserting }
GtLlmModelFileExamples >> assert: actual equals: expected [
	^ self
		assert: expected = actual
		description: [self comparingStringBetween: actual and: expected]
]

{ #category : #asserting }
GtLlmModelFileExamples >> assertCollection: actual hasSameElements: expected [
	"Assert that a collection contains the same elements as the given collection. Order is not checked, only the presence/absence of elements."
	| missingElements additionalElements |
	
	additionalElements := actual difference: expected.
	missingElements := expected difference: (actual intersection: expected).
	self 
		assert: (additionalElements isEmpty and: [ missingElements isEmpty ])
		description: (String streamContents: 
			[:stream |
			stream
				nextPutAll: 'Given Collections do not match!'; lf;
				tab; nextPutAll: 'additions : '; print: additionalElements asArray; lf;
				tab; nextPutAll: 'missing: '; print: missingElements asArray; lf ])
]

{ #category : #asserting }
GtLlmModelFileExamples >> classForTestResult [
	"Returns the class of the test result"
	^ GtExampleResult
]

{ #category : #private }
GtLlmModelFileExamples >> comparingStringBetween: actual and: expected [

	^ String streamContents: [:stream |
			stream
				nextPutAll: 'Got ';
				nextPutAll: actual fullPrintString;
				nextPutAll: ' instead of ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.']
]

{ #category : #asserting }
GtLlmModelFileExamples >> executeShould: aBlock inScopeOf: anExceptionalEvent [ 
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: true]
]

{ #category : #'as yet unclassified' }
GtLlmModelFileExamples >> modelfile [
	<gtExample>
	| modelfile |
	modelfile := GtLlmModelFile new.

	self assert: modelfile content equals: ''.
	self assert: modelfile directives isEmpty.

	^ modelfile
]

{ #category : #'as yet unclassified' }
GtLlmModelFileExamples >> modelfileWithMessages [
	<gtExample>
	| modelfile |
	modelfile := self modelfile.

	modelfile addMessage: GtLlmMessageExamples new userMessage.
	modelfile addMessage: GtLlmMessageExamples new assistantMessage.

	self assert: modelfile directives size equals: 2.

	^ modelfile
]

{ #category : #'as yet unclassified' }
GtLlmModelFileExamples >> modelfileWithSystem [
	<gtExample>
	| modelfile |
	modelfile := self modelfile.

	modelfile system: 'You are a helpfule assistant'.

	self assert: modelfile directives size equals: 1.

	^ modelfile
]

{ #category : #asserting }
GtLlmModelFileExamples >> should: aBlock raise: anExceptionalEvent [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
]

{ #category : #asserting }
GtLlmModelFileExamples >> should: aBlock raise: anExceptionalEvent description: aString [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
			
]

{ #category : #asserting }
GtLlmModelFileExamples >> shouldnt: aBlock raise: anExceptionalEvent [  
	 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
			
]

{ #category : #asserting }
GtLlmModelFileExamples >> shouldnt: aBlock raise: anExceptionalEvent description: aString [  
 
	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
		description: aString
]

{ #category : #signalling }
GtLlmModelFileExamples >> signalFailure: aString [
	self classForTestResult failure signal: aString
]
