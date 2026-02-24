Class {
	#name : #GtLDemoMathReasoning,
	#superclass : #Object,
	#instVars : [
		'steps',
		'finalAnswer'
	],
	#category : 'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparison }
GtLDemoMathReasoning >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ finalAnswer = anObject finalAnswer and: [
		steps = anObject steps ]
]

{ #category : #'api - ui' }
GtLDemoMathReasoning >> addContentOneLineSummaryTo: aWriteStream [
	self steps
		do: [ :eachStep | eachStep addContentOneLineSummaryTo: aWriteStream ]
		separatedBy: [ aWriteStream space ]
]

{ #category : #'api - ui' }
GtLDemoMathReasoning >> contentOneLineMultiLabelSummaryWith: aBuilder [
	self steps
		do: [ :eachStep | eachStep contentOneLineMultiLabelSummaryWith: aBuilder ]
		separatedBy: [  ]
]

{ #category : #'as yet unclassified' }
GtLDemoMathReasoning >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Math reasoning is made out of steps.'
]

{ #category : #accessing }
GtLDemoMathReasoning >> finalAnswer [
	^ finalAnswer
]

{ #category : #accessing }
GtLDemoMathReasoning >> finalAnswer: anObject [
	finalAnswer := anObject
]

{ #category : #accessing }
GtLDemoMathReasoning >> finalAnswerDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #finalAnswer;
		  beRequired
]

{ #category : #views }
GtLDemoMathReasoning >> gtStepsFor: aView [
	<gtView>
	<gtLlmView>
	
	steps ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Reasoning steps';
		priority: 10;
		items: [ steps ];
		column: 'Explanation' text: [ :each | each explanation ];
		column: 'Value' text: [ :each | each output ]
]

{ #category : #comparing }
GtLDemoMathReasoning >> hash [
	^ (self class hash hashMultiply 
		bitXor: finalAnswer hash hashMultiply)
		bitXor: steps hash hashMultiply
]

{ #category : #'as yet unclassified' }
GtLDemoMathReasoning >> initialize [
	super initialize.
	steps := OrderedCollection new.
]

{ #category : #views }
GtLDemoMathReasoning >> printOn: aStream [
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
GtLDemoMathReasoning >> steps [
	^ steps
]

{ #category : #accessing }
GtLDemoMathReasoning >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
GtLDemoMathReasoning >> stepsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #steps;
			classes: {GtLDemoMathReasoningStep};
			beRequired
]
