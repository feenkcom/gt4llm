"
I am a plain element containing the expander for an assistant's final reply. I own the preview and reply tabs, retain expansion and tab choices in the message view model, and reuse the assistant comment editor. My disclosure sidebar shares the work element's top-padding baseline; the collapsed preview has no additional outer margin.
"
Class {
	#name : #GtLACPAssistantFinalMessageElement,
	#superclass : #BlElement,
	#instVars : [
		'messageViewModel',
		'commentElement',
		'previewElement',
		'expander'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPAssistantFinalMessageElement >> build [
	expander
		id: messageViewModel finalSectionId;
		header: [ self buildPreview ];
		content: [ self buildContent ].
	((expander childNamed: #sidebar) childNamed: #'expander--toggle')
		id: messageViewModel finalToggleId.
	expander expanded: messageViewModel isFinalReplyExpanded.
	expander whenExpandedDo: [ messageViewModel finalReplyExpanded: true ].
	expander whenCollapsedDo: [ messageViewModel finalReplyExpanded: false ]
]

{ #category : #building }
GtLACPAssistantFinalMessageElement >> buildContent [
	| pane tabs views |
	views := messageViewModel message
			finalReplyViewsInContext: messageViewModel phlowContext.
	views := views
			collect: [ :view | 
				view title = 'Markdown'
					ifTrue: [ view
							stencil: [ | element |
								element := commentElement.
								element removeFromParent.
								element id: #'acp-final-message'.
								element editor id: #'acp-final-text'.
								element ] ]
					ifFalse: [ view ] ].
	tabs := GtPhlowCompositeView new
			views: views;
			asElementDo: [ :element | 
				element
					hMatchParent;
					vFitContentLimited ].
	tabs id: messageViewModel finalTabsId.
	tabs selectTabWithLabelString: messageViewModel selectedFinalViewTitle.
	tabs viewModel
		when: BrTabSelectedEvent
		do: [ :event | messageViewModel selectedFinalViewTitle: event tab tabLabel text asString ].
	pane := BrVerticalPane new
			id: messageViewModel finalContentId;
			hMatchParent;
			vFitContentLimited;
			addChild: tabs;
			yourself.
	^ pane
]

{ #category : #initialization }
GtLACPAssistantFinalMessageElement >> buildPreview [
	previewElement := BrEditor new
			id: messageViewModel finalPreviewId;
			aptitude: BrGlamorousRegularEditorAptitude;
			padding: (BlInsets
					top: 4
					left: 5
					bottom: 0
					right: 5);
			beReadOnlyWithSelection;
			hMatchParent;
			vFitContent;
			yourself.
	self updatePreview.
	^ previewElement
]

{ #category : #accessing }
GtLACPAssistantFinalMessageElement >> commentElement [
	^ commentElement
]

{ #category : #accessing }
GtLACPAssistantFinalMessageElement >> commentElement: anElement [
	commentElement := anElement
]

{ #category : #accessing }
GtLACPAssistantFinalMessageElement >> expander [
	^ expander
]

{ #category : #initialization }
GtLACPAssistantFinalMessageElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	expander := BrExpander new
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
			yourself.
	self addChild: expander as: #expander
]

{ #category : #accessing }
GtLACPAssistantFinalMessageElement >> messageViewModel [
	^ messageViewModel
]

{ #category : #accessing }
GtLACPAssistantFinalMessageElement >> messageViewModel: aViewModel [
	messageViewModel := aViewModel.
	self build
]

{ #category : #updating }
GtLACPAssistantFinalMessageElement >> refresh [
	commentElement refresh.
	self updatePreview.
	expander expanded: messageViewModel isFinalReplyExpanded
]

{ #category : #accessing }
GtLACPAssistantFinalMessageElement >> replyPreviewText [
	| text |
	text := String
			streamContents: [ :stream | 
				messageViewModel replyMessages
					do: [ :message | stream nextPutAll: message text ] ].
	text := (text copyReplaceAll: String cr with: ' ')
			copyReplaceAll: String lf
			with: ' '.
	^ text size > 180 ifTrue: [ (text first: 180) , '…' ] ifFalse: [ text ]
]

{ #category : #updating }
GtLACPAssistantFinalMessageElement >> updatePreview [
	| text |
	previewElement ifNil: [ ^ self ].
	text := self replyPreviewText.
	previewElement text asString = text ifTrue: [ ^ self ].
	previewElement
		text: (GtLMessageStyler new
				objectRegistry: messageViewModel phlowContext objectRegistry;
				privateStyle: text asRopedText)
]
