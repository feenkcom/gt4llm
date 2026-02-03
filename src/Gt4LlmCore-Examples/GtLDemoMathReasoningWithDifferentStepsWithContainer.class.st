Class {
	#name : #GtLDemoMathReasoningWithDifferentStepsWithContainer,
	#superclass : #Object,
	#instVars : [
		'steps',
		'finalAnswer'
	],
	#category : 'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparison }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ finalAnswer = anObject finalAnswer and: [
		steps = anObject steps ]
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> finalAnswer [
	^ finalAnswer
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> finalAnswer: anObject [
	finalAnswer := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> finalAnswerDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #finalAnswer;
		  beRequired
]

{ #category : #views }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> gtStepsFor: aView [
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
GtLDemoMathReasoningWithDifferentStepsWithContainer >> hash [
	^ (self class hash hashMultiply 
		bitXor: finalAnswer hash hashMultiply)
		bitXor: steps hash hashMultiply
]

{ #category : #views }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> printOn: aStream [
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
GtLDemoMathReasoningWithDifferentStepsWithContainer >> steps [
	^ steps
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningWithDifferentStepsWithContainer >> stepsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #steps;
			classes: {
				GtLDemoMathReasoningExplanationStep . GtLDemoMathReasoningOutputStep};
			useExplicitContainerForChildren;
			beRequired
]
