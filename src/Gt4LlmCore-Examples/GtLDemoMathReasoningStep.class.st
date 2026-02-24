Class {
	#name : #GtLDemoMathReasoningStep,
	#superclass : #Object,
	#instVars : [
		'explanation',
		'output'
	],
	#category : 'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparison }
GtLDemoMathReasoningStep >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ explanation = anObject explanation and: [
		output = anObject output ]
]

{ #category : #'api - ui' }
GtLDemoMathReasoningStep >> addContentOneLineSummaryTo: aWriteStream [
	self explanation
		ifNotNil: [ :aString | 
			aWriteStream nextPutAll: aString asString.
			aWriteStream nextPutAll: ': ' ].

	self output ifNotNil: [ :aString | 
		aWriteStream nextPutAll: aString asString ]
]

{ #category : #'api - ui' }
GtLDemoMathReasoningStep >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]

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

{ #category : #comparing }
GtLDemoMathReasoningStep >> hash [
	^ (self class hash hashMultiply 
		bitXor: explanation hash hashMultiply)
		bitXor: output hash hashMultiply
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
