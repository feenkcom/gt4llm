Class {
	#name : #GtLDemoMathReasoningBasicStep,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #accessing }
GtLDemoMathReasoningBasicStep >> description [
	self subclassResponsibility
]

{ #category : #printing }
GtLDemoMathReasoningBasicStep >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [ 
		aStream 
			<< self description ]
]
