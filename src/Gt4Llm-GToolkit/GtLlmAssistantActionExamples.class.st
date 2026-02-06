Class {
	#name : #GtLlmAssistantActionExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-GToolkit-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmAssistantActionExamples >> actionWithExampleWithJsonContainingQuote [
	<gtExample>
	<return: #GtLlmAssistantAction>
	| action |
	action := GtLlmAssistantAction new
			name: 'Some action';
			description: 'Some description.';
			addExample: self exampleWithJsonContainingQuote.
	self shouldnt: [ RBParser parseMethod: action asMethodSource ] raise: Error.
	^ action
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> assert: aBoolean [
	"We check for true explicitly to make the assertion fail for non booleans"
	aBoolean == true ifFalse: [self signalFailure: 'Assertion failed']
			
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> assert: aBooleanOrBlock description: aStringOrBlock [
	aBooleanOrBlock value ifFalse: [
		| message |
		message := aStringOrBlock value.
		self classForTestResult failure signal: message]
			
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> assert: actual equals: expected [
	^ self
		assert: expected = actual
		description: [self comparingStringBetween: actual and: expected]
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> assertCollection: actual hasSameElements: expected [
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
GtLlmAssistantActionExamples >> classForTestResult [
	"Returns the class of the test result"
	^ GtExampleResult
]

{ #category : #private }
GtLlmAssistantActionExamples >> comparingStringBetween: actual and: expected [

	^ String streamContents: [:stream |
			stream
				nextPutAll: 'Got ';
				nextPutAll: actual fullPrintString;
				nextPutAll: ' instead of ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.']
]

{ #category : #'as yet unclassified' }
GtLlmAssistantActionExamples >> exampleWithJsonContainingQuote [
	<gtExample>
	<return: #GtLlmAssistantActionExample>
	| jsonString json example |
	jsonString := '{"Action":"Some action","Text":"Some text","Post":"String with '' inside."}'.
	json := STONJSON fromString: jsonString.
	example := GtLlmAssistantActionExample new
			input: json;
			output: json.
	self
		shouldnt: [ RBParser parseExpression: example asExpressionSource ]
		raise: Error.
	^ example
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> executeShould: aBlock inScopeOf: anExceptionalEvent [ 
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: true]
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> should: aBlock raise: anExceptionalEvent [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> should: aBlock raise: anExceptionalEvent description: aString [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
			
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> shouldnt: aBlock raise: anExceptionalEvent [  
	 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
			
]

{ #category : #asserting }
GtLlmAssistantActionExamples >> shouldnt: aBlock raise: anExceptionalEvent description: aString [  
 
	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
		description: aString
]

{ #category : #signalling }
GtLlmAssistantActionExamples >> signalFailure: aString [
	self classForTestResult failure signal: aString
]
