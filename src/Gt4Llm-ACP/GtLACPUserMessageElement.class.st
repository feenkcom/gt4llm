"
I render a user prompt with selectable styled text. A message view model creates and builds me.
"
Class {
	#name : #GtLACPUserMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPUserMessageElement >> buildContent [
	self buildPromptSection
]

{ #category : #building }
GtLACPUserMessageElement >> buildPromptSection [
	| expander |
	expander := BrExpander new
			id: viewModel promptSectionId;
			aptitude: (BrGlamorousExpanderSubtleAptitude new
					sidebarExtraPadding: (BlInsets top: 9);
					yourself);
			hMatchParent;
			vFitContent;
			margin: (BlInsets top: 4 bottom: 4);
			header: [ self promptPreview ];
			content: [ self promptContent ];
			yourself.
	((expander childNamed: #sidebar) childNamed: #'expander--toggle')
		id: viewModel promptToggleId.
	expander expanded: viewModel isPromptExpanded.
	expander whenExpandedDo: [ viewModel promptExpanded: true ].
	expander whenCollapsedDo: [ viewModel promptExpanded: false ].
	self addChild: expander
]

{ #category : #building }
GtLACPUserMessageElement >> promptContent [
	^ BrVerticalPane new
		hMatchParent;
		vFitContent;
		addChild: (self textElementFor: viewModel message text);
		yourself
]

{ #category : #building }
GtLACPUserMessageElement >> promptPreview [
	^ (self textElementFor: self replyPreviewText)
		id: viewModel promptPreviewId;
		vExact: 24;
		yourself
]
