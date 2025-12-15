Class {
	#name : #GtLDemoMathReasoning,
	#superclass : #Object,
	#instVars : [
		'steps',
		'finalAnswer'
	],
	#category : #'Gt4LlmCore-Examples'
}

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
	steps ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Steps';
		items: [ steps ];
		column: 'Explanation' text: [ :each | each explanation ];
		column: 'Value' text: [ :each | each output ]
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
