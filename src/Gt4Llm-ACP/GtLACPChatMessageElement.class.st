"
I share layout, message headers and selectable text rendering between user and assistant elements. My view model configures and builds me once. Assigning the view model does not change my children.
"
Class {
	#name : #GtLACPChatMessageElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'viewModel'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #ui }
GtLACPChatMessageElement >> build [
	self addChild: self buildHeader as: #'acp-message-header'.
	self buildContent.
	self
		addAptitude: (BrLazyStyleCommonAptitude new
				when: BlElementState hovered
				style: [ :style :aTheme | 
					style
						do: [ :widget | widget showHoverDetails ]
						after: [ :widget | widget hideHoverDetails ] ])
]

{ #category : #ui }
GtLACPChatMessageElement >> buildContent [
 self subclassResponsibility
]

{ #category : #ui }
GtLACPChatMessageElement >> buildHeader [
 | header sender timestamp inspect |
 header := BrHorizontalPane new hMatchParent; vFitContent; yourself.
 sender := BrLabel new
  aptitude: BrGlamorousLabelAptitude;
  text: viewModel label;
  background: self theme default backdropBackground;
  geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
  padding: (BlInsets left: 2 right: 2);
  constraintsDo: [ :c | c linear vertical alignTop ]; yourself.
 timestamp := BrLabel new id: #'acp-timestamp';
  aptitude: (BrGlamorousLabelAptitude new foreground: BrGlamorousColors disabledButtonTextColor);
  text: viewModel dateString; margin: (BlInsets left: 10 right: 10);
  visibility: BlVisibility hidden; yourself.
 inspect := BrButton new id: #'acp-inspect';
  aptitude: BrGlamorousButtonWithIconAptitude;
  beSmallSize; label: 'Inspect message'; icon: BrGlamorousVectorIcons inspect;
  visibility: BlVisibility hidden;
  action: [ :button | button phlow spawnObject: viewModel inspectionTarget ]; yourself.
 header addChild: sender; addChild: timestamp.
 header addChild: (BrFrame new hMatchParent; vExact: 0; yourself).
 header addChild: inspect.
 ^ header
]

{ #category : #ui }
GtLACPChatMessageElement >> hideHoverDetails [
 | header |
 header := self childNamed: #'acp-message-header'.
 (header childNamed: #'acp-timestamp') visibility: BlVisibility hidden.
 (header childNamed: #'acp-inspect') visibility: BlVisibility hidden
]

{ #category : #ui }
GtLACPChatMessageElement >> initialize [
	super initialize.
	self
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 5);
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5);
		background: self theme default contentBackground;
		addAptitude: BlGlamorousExpanderShadowAptitude new
]

{ #category : #building }
GtLACPChatMessageElement >> messageSection: aName header: aHeaderBlock content: aBlock [
 ^ self messageSection: aName header: aHeaderBlock content: aBlock
  aptitude: (BrGlamorousExpanderSubtleAptitude new
   sidebarExtraPadding: (BlInsets top: (aName = #work ifTrue: [ 6 ] ifFalse: [ 9 ]));
   yourself)
]

{ #category : #building }
GtLACPChatMessageElement >> messageSection: aName header: aHeaderBlock content: aBlock aptitude: anAptitude [
 | expander model |
 model := viewModel.
 expander := BrExpander new.
 expander id: (model elementIdFor: aName asString, '-section');
  aptitude: anAptitude;
  hMatchParent; vFitContent; margin: (BlInsets top: 4 bottom: 4);
  header: [ aHeaderBlock value: expander ];
  content: aBlock; yourself.
 ((expander childNamed: #sidebar) childNamed: #'expander--toggle')
  id: (model elementIdFor: aName asString, '-toggle').
 expander expanded: (model isSectionExpanded: aName).
 expander whenExpandedDo: [ model section: aName expanded: true ].
 expander whenCollapsedDo: [ model section: aName expanded: false ].
 ^ expander
]

{ #category : #ui }
GtLACPChatMessageElement >> replyPreviewText [
 | text |
 text := String streamContents: [ :stream |
  viewModel replyMessages do: [ :message | stream nextPutAll: message text ] ].
 text := (text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
 ^ text size > 180 ifTrue: [ (text first: 180), '…' ] ifFalse: [ text ]
]

{ #category : #ui }
GtLACPChatMessageElement >> showHoverDetails [
 | header |
 header := self childNamed: #'acp-message-header'.
 (header childNamed: #'acp-timestamp') visibility: BlVisibility visible.
 (header childNamed: #'acp-inspect') visibility: BlVisibility visible
]

{ #category : #building }
GtLACPChatMessageElement >> textElementFor: aString [
	| text styler |
	text := aString asRopedText.
	styler := GtLMessageStyler new
			objectRegistry: viewModel phlowContext objectRegistry;
			yourself.
	styler privateStyle: text.
	^ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude;
		beReadOnlyWithSelection;
		hMatchParent;
		vFitContentLimited;
		text: text;
		yourself
]

{ #category : #accessing }
GtLACPChatMessageElement >> viewModel [
 ^ viewModel
]

{ #category : #accessing }
GtLACPChatMessageElement >> viewModel: aViewModel [
 viewModel := aViewModel
]
