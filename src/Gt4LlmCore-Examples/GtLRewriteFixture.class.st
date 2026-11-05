Class {
	#name : #GtLRewriteFixture,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #fixtures }
GtLRewriteFixture >> sizeOf: aCollection [
	^aCollection size
]

{ #category : #fixtures }
GtLRewriteFixture >> valueOf: anObject [
	^anObject rewriteFixtureMessage
]
