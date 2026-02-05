Class {
	#name : #GtLDemoMathReasoningWithDelegatedSteps,
	#superclass : #Object,
	#instVars : [
		'steps',
		'finalAnswer'
	],
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparison }
GtLDemoMathReasoningWithDelegatedSteps >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ finalAnswer = anObject finalAnswer and: [
		steps = anObject steps ]
]

{ #category : #'api - ui' }
GtLDemoMathReasoningWithDelegatedSteps >> addContentOneLineSummaryTo: aWriteStream [
	self steps
		do: [ :eachStep | eachStep addContentOneLineSummaryTo: aWriteStream ]
		separatedBy: [ aWriteStream space ]
]

{ #category : #'api - ui' }
GtLDemoMathReasoningWithDelegatedSteps >> contentOneLineMultiLabelSummaryWith: aBuilder [
	self steps
		do: [ :eachStep | eachStep contentOneLineMultiLabelSummaryWith: aBuilder ]
		separatedBy: [  ]
]

{ #category : #accessing }
GtLDemoMathReasoningWithDelegatedSteps >> finalAnswer [
	^ finalAnswer
]

{ #category : #accessing }
GtLDemoMathReasoningWithDelegatedSteps >> finalAnswer: anObject [
	finalAnswer := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningWithDelegatedSteps >> finalAnswerDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #finalAnswer;
		  beRequired
]

{ #category : #views }
GtLDemoMathReasoningWithDelegatedSteps >> gtStepsFor: aView [
	<gtView>
	<gtLlmView>
	
	steps ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Reasoning steps';
		priority: 10;
		items: [ steps ];
		column: 'Type' text: [ :each | each step class name ];
		column: 'Step' text: [ :each | each description ]
]

{ #category : #comparing }
GtLDemoMathReasoningWithDelegatedSteps >> hash [
	^ (self class hash hashMultiply 
		bitXor: finalAnswer hash hashMultiply)
		bitXor: steps hash hashMultiply
]

{ #category : #views }
GtLDemoMathReasoningWithDelegatedSteps >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [ 
		aStream 
			print: self steps size;
			<< ' ';
			<< ('step' asPluralBasedOn: self steps size);
			<< '; finalAnswer: ';
			<< self finalAnswer ]
]

{ #category : #accessing }
GtLDemoMathReasoningWithDelegatedSteps >> steps [
	^ steps
]

{ #category : #accessing }
GtLDemoMathReasoningWithDelegatedSteps >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningWithDelegatedSteps >> stepsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #steps;
			classes: {GtLDemoMathReasoningDelegatedStep};
			beRequired
]
