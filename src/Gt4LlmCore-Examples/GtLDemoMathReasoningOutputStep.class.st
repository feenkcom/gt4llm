Class {
	#name : #GtLDemoMathReasoningOutputStep,
	#superclass : #GtLDemoMathReasoningBasicStep,
	#instVars : [
		'output'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #comparison }
GtLDemoMathReasoningOutputStep >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ output = anObject output 
]

{ #category : #accessing }
GtLDemoMathReasoningOutputStep >> description [
	^ self output
]

{ #category : #comparing }
GtLDemoMathReasoningOutputStep >> hash [
	^ self class hash hashMultiply bitXor: output hash hashMultiply
]

{ #category : #accessing }
GtLDemoMathReasoningOutputStep >> output [
	^ output
]

{ #category : #accessing }
GtLDemoMathReasoningOutputStep >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningOutputStep >> outputDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #output;
		  beRequired
]
