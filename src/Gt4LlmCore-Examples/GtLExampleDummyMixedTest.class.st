Class {
	#name : #GtLExampleDummyMixedTest,
	#superclass : #TestCase,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testError [
	self error: 'Boom'
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testExpectedFailure [
	<expectedFailure>
	self assert: false
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testFailure [
	self assert: false
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testPass [
	self assert: true
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testSkip [
	self skip: 'Not today'
]
