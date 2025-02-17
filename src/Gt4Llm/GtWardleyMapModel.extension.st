Extension { #name : #GtWardleyMapModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> menuItemCreateTopicSection [
	<wardleyContextMenuItem: 41>
	^ GtWardleyMapStencilMenuItem new
		name: 'Create nodes on topic using OpenAI';
		block: [ :aContextMenuItem | 
			| editor |
			BrVerticalPane new
				fitContent;
				margin: GtWardleyMapUtility menuItemLabelMarginInsets;
				addChild: (BrLabel new
						fitContent;
						aptitude: (BrGlamorousLabelAptitude new foreground: Color darkGray);
						text: 'Create nodes on topic using OpenAI:');
				addChild: (BrHorizontalPane new
						fitContent;
						margin: (BlInsets top: 3);
						addChild: (editor := BrEditor new
									margin: (BlInsets right: 5);
									hExact: GtWardleyMapConstants menuItemEditorWidth;
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
								action: [ aContextMenuItem llm
										sendAction: (GtLlmActionCall action: 'Create a set of nodes' arguments: {editor text})
										onAnswer: [ :aMessage | 
											aContextMenuItem wardleyMapViewModel onActionFinished.
											GtWardleyMapUtility
												addModelAsPropositionsFrom: aContextMenuItem wardleyMapViewModel wardleyMapModel
												to: aMessage mapModel ].
									aContextMenuItem wardleyMapViewModel onActionStarted.
									aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ])) ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> menuItemReviewMapButton [
	<wardleyContextMenuItem: 45>
	^ GtWardleyMapNodeButtonWithLabelMenuItem new
		label: 'Review the current state';
		action: [ :aContextMenuItem :aBrButton :aBrButtonModel :anEvent | 
			aContextMenuItem llm
				sendAction: (GtLlmActionCall action: 'Review the current state' arguments: {})
				onAnswer: [ :aMessage | 
					aContextMenuItem wardleyMapViewModel onActionFinished.
					aContextMenuItem editorElement phlow spawnObject: aMessage textBlock ].
			aContextMenuItem wardleyMapViewModel onActionStarted.
			aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> openAIWardleyMapCreator: aCreator [
	^ self optionAt: #openAIWardleyMapCreator put: aCreator
]
