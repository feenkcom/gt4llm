Extension { #name : #GtWardleyMapModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ self isAITutorChatAvailable
		ifTrue: [ (self openAITutorChat gtMessagesWidgetFor: aView)
			title: 'Open AI Chat';
			priority: 5 ]
		ifFalse: [ aView empty ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> isAITutorChatAvailable [
	^ self
		optionAt: #openAITutorChat
		ifPresent: [ true ]
		ifAbsent: [ GtOpenAIGtTutor isTutorAvailable  ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> menuItemCreateTopicSection [
	<wardleyContextMenuItem: 20>
	^ GtWardleyMapStencilMenuItem new
		name: 'Create nodes on topic using OpenAI';
		condition: [ :aContextMenuItem | aContextMenuItem isLlmConnected ];
		block: [ :aContextMenuItem | 
			| editor |
			BrVerticalPane new
				fitContent;
				margin: (BlInsets top: 10);
				addChild: (BrLabel new
						aptitude: (BrGlamorousLabelAptitude new foreground: Color darkGray);
						text: 'Create nodes on topic:');
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
								action: [ aContextMenuItem llmCreator
										announce: (GtLlmSendActionToChat action: 'Create a set of nodes' arguments: {editor text}).
									aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ])) ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> openAITutorChat [
	^ self
		optionAt: #openAITutorChat
		ifAbsentPut: [ GtOpenAIWardleyMapActionTutor instance addChat ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> openAIWardleyMapCreator [
	<return: #GtLlmActionWardleyMapCreator or: nil>
	^ self
		optionAt: #openAIWardleyMapCreator
		ifAbsent: [ self isAITutorChatAvailable
				ifTrue: [ self openAITutorChat pipeline instance ]
				ifFalse: [ nil ] ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> openAIWardleyMapCreator: aCreator [
	^ self optionAt: #openAIWardleyMapCreator put: aCreator
]
