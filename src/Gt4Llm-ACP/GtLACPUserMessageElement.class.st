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

{ #category : #initialization }
GtLACPUserMessageElement >> buildPromptSection [
	| expander |
	expander := BrExpander new
			id: viewModel promptSectionId;
			aptitude: (BrGlamorousExpanderSubtleAptitude new
					padding: (BlInsets
							top: 0
							left: 4
							bottom: 0
							right: 4);
					sidebarExtraPadding: (BlInsets top: 10);
					yourself);
			hMatchParent;
			vFitContent;
			margin: (BlInsets top: 4);
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
GtLACPUserMessageElement >> previewTextLimit [
	^ 100
]

{ #category : #building }
GtLACPUserMessageElement >> promptContent [
	^ GtLACPMessageTextElement new
		phlowContext: viewModel phlowContext;
		message: viewModel message;
		yourself
]

{ #category : #initialization }
GtLACPUserMessageElement >> promptPreview [
	^ (self textElementFor: self replyPreviewText)
		id: viewModel promptPreviewId;
		padding: (BlInsets
				top: 4
				left: 5
				bottom: 0
				right: 5);
		vFitContent;
		yourself
]
