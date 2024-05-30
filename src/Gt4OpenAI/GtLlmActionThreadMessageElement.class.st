Class {
	#name : #GtLlmActionThreadMessageElement,
	#superclass : #GtLlmThreadMessageElement,
	#instVars : [
		'actionElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtLlmActionThreadMessageElement >> initialize [
	super initialize.

	self initializeActionElement.

	headerElement hMatchParent.
	headerElement addChild: BrFrame new matchParent as: #spacer.
	headerElement addChild: actionElement as: #action
]

{ #category : #accessing }
GtLlmActionThreadMessageElement >> initializeActionElement [
	actionElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: ''
]

{ #category : #accessing }
GtLlmActionThreadMessageElement >> updateActionElement [
	self threadMessageViewModel action
		ifNotNil: [ actionElement text: self threadMessageViewModel action ]
]

{ #category : #accessing }
GtLlmActionThreadMessageElement >> updateElement [
	super updateElement.
	
	self updateActionElement
]
