"
A details element for rendering code changes in summarizer views.
"
Class {
	#name : #GtLCodeChangesDetailsElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'codeChange',
		'iconContainerElement',
		'descriptionContainerElement'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLCodeChangesDetailsElement >> codeChange: aCodeChange [
	codeChange := aCodeChange.
	self updateForCodeChange
]

{ #category : #initialization }
GtLCodeChangesDetailsElement >> initialize [
	super initialize.
	
	self hMatchParent.
	self vFitContent.
	self alignCenter.
	
	self initializeIconContainer.
	self initializeDescriptionContainer.
	
	self addChild: iconContainerElement.
	self addChild: descriptionContainerElement
]

{ #category : #initialization }
GtLCodeChangesDetailsElement >> initializeDescriptionContainer [
	descriptionContainerElement := BrHorizontalPane new
		hMatchParent;
		vFitContent
]

{ #category : #initialization }
GtLCodeChangesDetailsElement >> initializeIconContainer [
	iconContainerElement := BrHorizontalPane new
		alignCenter;
		fitContent;
		padding: (BlInsets left: 5 right: 5)
]

{ #category : #updating }
GtLCodeChangesDetailsElement >> updateForCodeChange [
	iconContainerElement removeChildren.
	iconContainerElement addChild: codeChange gtViewChangeIcon asElement.
	descriptionContainerElement removeChildren.
	descriptionContainerElement addChild: codeChange gtViewChangeDescriptionElement
]
