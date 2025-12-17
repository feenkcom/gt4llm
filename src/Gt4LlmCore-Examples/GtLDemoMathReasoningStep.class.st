Class {
	#name : #GtLDemoMathReasoningStep,
	#superclass : #Object,
	#instVars : [
		'explanation',
		'output'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #accessing }
GtLDemoMathReasoningStep >> explanation [
	^ explanation
]

{ #category : #accessing }
GtLDemoMathReasoningStep >> explanation: anObject [
	explanation := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningStep >> explanationDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #explanation;
		  comment: 'An explanation of this step';
		  beRequired
]

{ #category : #accessing }
GtLDemoMathReasoningStep >> output [
	^ output
]

{ #category : #accessing }
GtLDemoMathReasoningStep >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningStep >> outputDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #output;
		  beRequired
]

{ #category : #printing }
GtLDemoMathReasoningStep >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [ 
		aStream 
			<< self output;
			<< '; ';
			<< self explanation ]
]
