Extension { #name : #GtOpenAIActionMessage }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIActionMessage >> gtChatRequestFor: aView [
	<gtView>
	<gtLlmMessageView>
	(self action beginsWith: 'Chat:') ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Message';
		priority: 1;
		text: [ self action removePrefix: 'Chat: ' ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIActionMessage >> gtReifyAcceptActionFor: anAction [
	<gtLlmAction>
	self action = 'Confirmation' ifFalse: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons accept;
		tooltip: 'Confirm';
		action: [ :aButton | self chat sendChatRequest: 'Confirmed.' ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIActionMessage >> gtReifyActionFor: anAction [
	<gtLlmAction>
	(self isAssistantRole
		and: [ self action = 'Chat'
				or: [ (self action beginsWith: 'Chat: ') or: [ self actionModel isNil ] ] ])
		ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Reify action';
		content: [ :anElement | 
			GtLlmActionTemplateElement new
				example: (GtLlmAssistantActionExample new
						input: self ancestor contentJson;
						output: self contentJson);
				onActionCreated: [ :action | 
					self chat assistant class compile: action.
					self chat assistant recomputeActions.
					anElement phlow fireToolUpdateWish.
					anElement fireEvent: BrDropdownHideWish new ];
				padding: (BlInsets all: 5) ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIActionMessage >> gtReifyMessageActionFor: anAction [
	<gtLlmAction>
	^ anAction dropdown
		priority: 1;
		label: 'Reify';
		content: [ :aButton | 
			(GtLlmReificationForm new
				message: self;
				onAccept: [ :aValue | 
					aButton
						enqueueTask: (BlTaskAction new
								action: [ aButton phlow fireToolUpdateWish.
									aButton fireEvent: BrDropdownHideWish new ]) ]) asElement
				margin: (BlInsets all: 5) ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIActionMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	self textBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: -1;
		styler: (BlCompositeStyler new
				stylers: {
					GtLlmMessageStyler new
							threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new).
					GtLlmThreadMessageStyler new annotations: self annotations});
		text: [ self textBlock ]
]
