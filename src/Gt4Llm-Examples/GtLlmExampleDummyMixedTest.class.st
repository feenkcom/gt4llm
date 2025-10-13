Class {
	#name : #GtLlmExampleDummyMixedTest,
	#superclass : #TestCase,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmExampleDummyMixedTest >> testError [
	self error: 'Boom'
]

{ #category : #'llm-generated' }
GtLlmExampleDummyMixedTest >> testExpectedFailure [
	<expectedFailure>
	self assert: false
]

{ #category : #'llm-generated' }
GtLlmExampleDummyMixedTest >> testFailure [
	self assert: false
]

{ #category : #'llm-generated' }
GtLlmExampleDummyMixedTest >> testPass [
	self assert: true
]

{ #category : #'llm-generated' }
GtLlmExampleDummyMixedTest >> testSkip [
	self skip: 'Not today'
]
