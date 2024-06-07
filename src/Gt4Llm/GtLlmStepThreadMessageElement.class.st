Class {
	#name : #GtLlmStepThreadMessageElement,
	#superclass : #GtLlmThreadMessageElement,
	#instVars : [
		'stepElement'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmStepThreadMessageElement >> initialize [
	super initialize.

	self initializeStepElement.

	headerElement hMatchParent.
	headerElement addChild: BrFrame new matchParent as: #spacer.
	headerElement addChild: stepElement as: #step
]

{ #category : #accessing }
GtLlmStepThreadMessageElement >> initializeStepElement [
	stepElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: ''
]

{ #category : #accessing }
GtLlmStepThreadMessageElement >> updateElement [
	super updateElement.
	
	self updateStepElement
]

{ #category : #accessing }
GtLlmStepThreadMessageElement >> updateStepElement [
	stepElement text: self threadMessageViewModel step name
]
