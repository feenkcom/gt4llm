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
		padding: (BlInsets
				top: 10
				bottom: 10
				left: 10
				right: 10);
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5);
		background: self theme default contentBackground;
		addAptitude: BlGlamorousExpanderShadowAptitude new.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 4)
]

{ #category : #building }
GtLACPChatMessageElement >> previewTextLimit [
	^ 180
]

{ #category : #building }
GtLACPChatMessageElement >> replyPreviewText [
	| text |
	text := String
			streamContents: [ :stream | viewModel replyMessages do: [ :message | stream nextPutAll: message text ] ].
	text := (text copyReplaceAll: String cr with: ' ')
			copyReplaceAll: String lf
			with: ' '.
	^ text size > self previewTextLimit
		ifTrue: [ (text first: self previewTextLimit) , '…' ]
		ifFalse: [ text ]
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
	| text |
	text := GtLMessageStyler new
			objectRegistry: viewModel phlowContext objectRegistry;
			privateStyle: aString asRopedText.
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
