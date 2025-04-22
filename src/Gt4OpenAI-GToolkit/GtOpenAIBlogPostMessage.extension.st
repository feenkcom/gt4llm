Extension { #name : #GtOpenAIBlogPostMessage }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIBlogPostMessage >> gtActionFor: aView [
	<gtView>
	| view |
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].

	view := aView textEditor
			title: 'Action';
			priority: 3;
			text: [ self action ].
	self chat
		ifNotNil: [ view
				actionButtonLabel: 'Action'
					action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ];
				styler: [ BlCompositeStyler new
						stylers: {GtLlmMessageStyler new threadMessageViewModel: self asViewModel.
								GtLlmThreadMessageStyler new annotations: self annotations.
								GtLlmTutorFormatTextStyler new tutor: self chat tutor} ] ].
	^ view
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIBlogPostMessage >> gtDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	self isUserRole ifTrue: [ ^ aView empty ].
	(self contentJson includesKey: 'Post') ifFalse: [ ^ aView empty ].
	^ aView diff
		title: 'Diff';
		priority: 2;
		from: [ self chat serializer instance value asString ];
		to: [ self contentJson at: 'Post' ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			action: [ :b | self chat serializer instance updateContent: (self contentJson at: 'Post') ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIBlogPostMessage >> gtInspectActionFor: anAction [
	<gtLlmAction>
	self actionModel ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Action';
		action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIBlogPostMessage >> gtReifyActionFor: anAction [
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
				example: (GtLlmTutorActionExample new
						input: self ancestor contentJson;
						output: self contentJson);
				onActionCreated: [ :action | 
					self chat tutor class compile: action.
					self chat tutor recomputeActions.
					anElement phlow fireToolUpdateWish.
					anElement fireEvent: BrDropdownHideWish new ];
				padding: (BlInsets all: 5) ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIBlogPostMessage >> gtReifyMessageActionFor: anAction [
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
GtOpenAIBlogPostMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	self textBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 1;
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new));
		text: [ self textBlock ]
]
