Class {
	#name : #GtLDemoMathReasoningWithDifferentSteps,
	#superclass : #Object,
	#instVars : [
		'steps',
		'finalAnswer'
	],
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparison }
GtLDemoMathReasoningWithDifferentSteps >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ finalAnswer = anObject finalAnswer and: [
		steps = anObject steps ]
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentSteps >> finalAnswer [
	^ finalAnswer
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentSteps >> finalAnswer: anObject [
	finalAnswer := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentSteps >> finalAnswerDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #finalAnswer;
		  beRequired
]

{ #category : #views }
GtLDemoMathReasoningWithDifferentSteps >> gtStepsFor: aView [
	<gtView>
	<gtLlmView>
	
	steps ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Reasoning steps';
		priority: 10;
		items: [ steps ];
		column: 'Type' text: [ :each | each class name ];
		column: 'Step' text: [ :each | each description ]
]

{ #category : #comparing }
GtLDemoMathReasoningWithDifferentSteps >> hash [
	^ (self class hash hashMultiply 
		bitXor: finalAnswer hash hashMultiply)
		bitXor: steps hash hashMultiply
]

{ #category : #views }
GtLDemoMathReasoningWithDifferentSteps >> printOn: aStream [
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
GtLDemoMathReasoningWithDifferentSteps >> steps [
	^ steps
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentSteps >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentSteps >> stepsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #steps;
			classes: {GtLDemoMathReasoningExplanationStep . GtLDemoMathReasoningOutputStep};
			beRequired
]
