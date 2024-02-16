Class {
	#name : #GtLlmEvaluatedCodeButtonAttribute,
	#superclass : #GtPlaygroundEvaluatedCodeButtonAttribute,
	#category : #'Gt4Llm-Stylers'
}

{ #category : #accessing }
GtLlmEvaluatedCodeButtonAttribute >> playgroundElementIn: aContainer [
	| anErrorElement |
	self result value hasErrors
		ifFalse: [ ^ super playgroundElementIn: aContainer ].

	anErrorElement := GtLlmCheckRunExecutionErrorElement new
			checkRunResult: self result value;
			hExact: 400;
			vFitContentLimited.

	aContainer
		padding: (BlInsets all: 5);
		border: (BlBorder paint: BrGlamorousColors errorBorderColor);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2).

	^ aContainer addChild: anErrorElement
]
