Class {
	#name : #GtLlmWardleyMapEditorElement,
	#superclass : #GtWardleyMapEditorElement,
	#instVars : [
		'creator',
		'topicSection'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapEditorElement >> createTopicSectionElement [
	| editor |
	^ BrVerticalPane new fitContent
		margin: (BlInsets top: 10);
		addChild: (BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color darkGray);
				text: (self creator topic isEmptyOrNil
						ifTrue: [ 'Create with topic:' ]
						ifFalse: [ 'Update topic' ]));
		addChild: (BrHorizontalPane new fitContent
				margin: (BlInsets top: 3);
				addChild: (editor := BrEditor new
							margin: (BlInsets right: 5);
							hExact: 150;
							vFitContent;
							geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
							aptitude: BrGlamorousRegularEditorAptitude new
									+ (BrStyleCommonAptitude new
											default: [ :aStyle | 
												aStyle
													border: (BlBorder paint: BrGlamorousColors disabledButtonBorderColor width: 1) ]));
				addChild: (BrButton new
						aptitude: BrGlamorousButtonWithIconAptitude;
						icon: BrGlamorousVectorIcons accept;
						label: 'Set topic';
						action: [ self creator
								announce: (GtLlmSendActionToChat action: 'Create an initial map' arguments: {editor text}).
							self fireEvent: BrContextMenuHideWish new ]))
]

{ #category : #accessing }
GtLlmWardleyMapEditorElement >> creator [
	^ creator
]

{ #category : #accessing }
GtLlmWardleyMapEditorElement >> creator: anObject [
	creator := anObject.
	
	self onCreatorUpdated
]

{ #category : #accessing }
GtLlmWardleyMapEditorElement >> onCreatorUpdated [
	topicSection ifNotNil: [ self removeChild: topicSection ].

	topicSection := self createTopicSectionElement.

	self addChild: topicSection
]
