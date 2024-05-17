Class {
	#name : #GtLlmStepResult,
	#superclass : #Object,
	#instVars : [
		'content',
		'checker',
		'input',
		'threadMessage'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmStepResult class >> prefix [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmStepResult >> asElement [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new
				foreground: self foregroundColor);
		background: self backgroundColor;
		text: self summaryString;
		fitContent;
		beSmallSize;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2)
]

{ #category : #accessing }
GtLlmStepResult >> asString [
	^ self class prefix, '
', self contentString
]

{ #category : #accessing }
GtLlmStepResult >> backgroundColor [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmStepResult >> chat [
	^ self checker chat
]

{ #category : #accessing }
GtLlmStepResult >> checker [
	^ checker
]

{ #category : #accessing }
GtLlmStepResult >> checker: anObject [
	checker := anObject
]

{ #category : #accessing }
GtLlmStepResult >> children [
	^ {}
]

{ #category : #accessing }
GtLlmStepResult >> content [
	^ content
]

{ #category : #accessing }
GtLlmStepResult >> content: aString [
	content := aString
]

{ #category : #accessing }
GtLlmStepResult >> contentString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmStepResult >> foregroundColor [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmStepResult >> gtContentFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons playinspect;
		tooltip: 'Inspect result';
		action: [ :aButton | aButton phlow spawnObject: self content ]
]

{ #category : #accessing }
GtLlmStepResult >> gtInputFor: aView [
	<gtView>
	^ aView forward
		title: 'Input';
		priority: 2;
		object: [ self input ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmStepResult >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 2;
		object: [ self content ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmStepResult >> gtResultFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Result';
		priority: 1;
		text: [ self asString ]
]

{ #category : #accessing }
GtLlmStepResult >> input [
	^ input
]

{ #category : #accessing }
GtLlmStepResult >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmStepResult >> isError [
	^ false
]

{ #category : #accessing }
GtLlmStepResult >> isExecuted [
	^ true
]

{ #category : #accessing }
GtLlmStepResult >> sendToChat [
	self threadMessage chat sendMessage: self asString
]

{ #category : #accessing }
GtLlmStepResult >> summaryString [
	^ self content
		ifNil: [ 'No value' ]
		ifNotNil: [ :aContent | aContent printStringLimitedTo: 20 ]
]

{ #category : #accessing }
GtLlmStepResult >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
GtLlmStepResult >> threadMessage: anObject [
	threadMessage := anObject
]
