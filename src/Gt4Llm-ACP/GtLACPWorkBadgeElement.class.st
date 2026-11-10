"
I display the small work-kind badge shared by tool calls and user questions.
"
Class {
	#name : #GtLACPWorkBadgeElement,
	#superclass : #BrLabel,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #initialization }
GtLACPWorkBadgeElement >> initialize [
	super initialize.
	self
		aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
		beSmallSize;
		background: self theme default backdropBackground;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets left: 2 right: 2);
		margin: (BlInsets right: 4);
		constraintsDo: [ :c | c linear vertical alignCenter ]
]
