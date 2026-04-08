Class {
	#name : #GtLlmMessageExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-GToolkit-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> actionMessage [
	<gtExample>
	| anActionMessage |
	anActionMessage := GtLlmActionMessage new
		role: 'assistant';
		content: '{"Action": "An Action"}'.
		
	self assert: anActionMessage action equals: 'An Action'.
	
	^ anActionMessage
]

{ #category : #asserting }
GtLlmMessageExamples >> assert: aBoolean [
	"We check for true explicitly to make the assertion fail for non booleans"
	aBoolean == true ifFalse: [self signalFailure: 'Assertion failed']
			
]

{ #category : #asserting }
GtLlmMessageExamples >> assert: aBooleanOrBlock description: aStringOrBlock [
	aBooleanOrBlock value ifFalse: [
		| message |
		message := aStringOrBlock value.
		self classForTestResult failure signal: message]
			
]

{ #category : #asserting }
GtLlmMessageExamples >> assert: actual equals: expected [
	^ self
		assert: expected = actual
		description: [self comparingStringBetween: actual and: expected]
]

{ #category : #asserting }
GtLlmMessageExamples >> assertCollection: actual hasSameElements: expected [
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

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> assistantMessage [
	<gtExample>
	^ GtLlmAssistantMessage new content: 'This is an assistant message'
]

{ #category : #asserting }
GtLlmMessageExamples >> classForTestResult [
	"Returns the class of the test result"
	^ GtExampleResult
]

{ #category : #private }
GtLlmMessageExamples >> comparingStringBetween: actual and: expected [

	^ String streamContents: [:stream |
			stream
				nextPutAll: 'Got ';
				nextPutAll: actual fullPrintString;
				nextPutAll: ' instead of ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.']
]

{ #category : #asserting }
GtLlmMessageExamples >> executeShould: aBlock inScopeOf: anExceptionalEvent [ 
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: true]
]

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> parsedMessage [
	<gtExample>
	| anAssistantMessage messageString |
	messageString := 'This is an assistant message'.
	anAssistantMessage := GtLlmChatMessage
			from: {'role' -> 'assistant'.
					'content' -> messageString} asDictionary.

	self assert: anAssistantMessage isAssistantRole.
	self assert: anAssistantMessage content equals: messageString.

	^ anAssistantMessage
]

{ #category : #asserting }
GtLlmMessageExamples >> should: aBlock raise: anExceptionalEvent [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
]

{ #category : #asserting }
GtLlmMessageExamples >> should: aBlock raise: anExceptionalEvent description: aString [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
			
]

{ #category : #asserting }
GtLlmMessageExamples >> shouldnt: aBlock raise: anExceptionalEvent [  
	 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
			
]

{ #category : #asserting }
GtLlmMessageExamples >> shouldnt: aBlock raise: anExceptionalEvent description: aString [  
 
	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
		description: aString
]

{ #category : #signalling }
GtLlmMessageExamples >> signalFailure: aString [
	self classForTestResult failure signal: aString
]

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> systemMessage [
	<gtExample>
	^ GtLlmSystemMessage new content: 'This is a system message'
]

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> userMessage [
	<gtExample>
	^ GtLlmUserMessage new content: 'This is a user message'
]
