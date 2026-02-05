Class {
	#name : #GtLDemoMathReasoningDelegatedStep,
	#superclass : #Object,
	#instVars : [
		'step'
	],
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparing }
GtLDemoMathReasoningDelegatedStep >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ step = anObject step 
]

{ #category : #'api - ui' }
GtLDemoMathReasoningDelegatedStep >> addContentOneLineSummaryTo: aWriteStream [
	self step addContentOneLineSummaryTo: aWriteStream
]

{ #category : #'api - ui' }
GtLDemoMathReasoningDelegatedStep >> contentOneLineMultiLabelSummaryWith: aBuilder [
	self step contentOneLineMultiLabelSummaryWith: aBuilder
]

{ #category : #accessing }
GtLDemoMathReasoningDelegatedStep >> description [
	^ self step description
]

{ #category : #comparing }
GtLDemoMathReasoningDelegatedStep >> hash [
	^ self class hash hashMultiply bitXor: step hash hashMultiply
]

{ #category : #printing }
GtLDemoMathReasoningDelegatedStep >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [ 
		aStream 
			<< self description ]
]

{ #category : #accessing }
GtLDemoMathReasoningDelegatedStep >> step [
	^ step
]

{ #category : #accessing }
GtLDemoMathReasoningDelegatedStep >> step: anObject [
	step := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningDelegatedStep >> stepDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #step;
			classes: {
				GtLDemoMathReasoningExplanationStep . 
				GtLDemoMathReasoningOutputStep};
			beRequired
]
