Class {
	#name : #GtLlmWardleyMapInProgressManager,
	#superclass : #Object,
	#instVars : [
		'element',
		'viewModel'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> addWidgetToElement [
	| addedChild |
	addedChild := BrHorizontalPane new fitContent
			id: self widgetId;
			padding: (BlInsets all: 5);
			addChild: BrGlamorousVectorIcons refresh asElement;
			addChild: (BrLabel new
					aptitude: BrGlamorousLabelAptitude new glamorousCodeFontAndSmallSize;
					text: 'LLM action in progress...').
	self element addChildFirst: addedChild
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> attach [
	self addWidgetToElement.
	self subscribeToAnnouncements
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> element [
	^ element
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> element: anObject [
	element := anObject
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> onRemovalAnnouncement: anAnnouncement [
	anAnnouncement decoratorViewModel = self viewModel ifTrue: [ self unattach ]
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> removeWidgetFromElement [
	self element removeChildNamed: self widgetId
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> subscribeToAnnouncements [
	self element wardleyMapViewModel announcer
		when: GtWardleyMapDecoratorViewModelRemoved
		send: #onRemovalAnnouncement:
		to: self
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> unattach [
	self removeWidgetFromElement.
	self unsubscribeFromAnnouncements
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> unsubscribeFromAnnouncements [
	self element wardleyMapViewModel unsubscribe: self
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> viewModel [
	^ viewModel
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> viewModel: anObject [
	viewModel := anObject
]

{ #category : #accessing }
GtLlmWardleyMapInProgressManager >> widgetId [
	^ #'llm-in-progress-widget'
]
