"
Element responsible for rendering a chat tool by collecting the chat-specific tool views and displaying them in a tab group.
"
Class {
	#name : #GtPhlowChatToolElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'chat'
	],
	#category : 'Gt4LlmCore-UI'
}

{ #category : #private }
GtPhlowChatToolElement >> buildHeaderElement [
	^ BrVerticalPane new
		padding: (BlInsets left: 5);
		vFitContent;
		hMatchParent;
		addChild: self buildToolLabel as: #toolLabel;
		yourself
]

{ #category : #private }
GtPhlowChatToolElement >> buildPlaygroundPageElement [
	| playgroundElement |
	playgroundElement := (GtInspector environment
		at: GtInspector embeddedPlaygroundName) new.
	playgroundElement collapse.
	^ playgroundElement
]

{ #category : #private }
GtPhlowChatToolElement >> buildToolLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
			foreground: Color gray;
			fontSize: 12);
		text: 'Chat'
]

{ #category : #private }
GtPhlowChatToolElement >> buildViewsContainerElement [
	^ BrFrame new
		matchParent
]

{ #category : #accessing }
GtPhlowChatToolElement >> chat [
	^ chat
]

{ #category : #accessing }
GtPhlowChatToolElement >> chat: aChat [
	chat := aChat.
	self updateContainedViews.
	self updatePlayground
]

{ #category : #private }
GtPhlowChatToolElement >> collectToolViews [
	| collectedViews |
	collectedViews := Array
		streamContents: [ :aStream |

			self gtInspectorTargetModels do: [ :eachTargetModel |
				aStream nextPutAll: (GtPhlowViewsCollector new
					fromObject: eachTargetModel;
					pragmaNames: GtLSettings messageViewPragmaNames;
					collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #private }
GtPhlowChatToolElement >> gtInspectorTargetModels [
	^ {self chat}, self chat gtInspectorTargetModels
]

{ #category : #initialization }
GtPhlowChatToolElement >> initialize [
	super initialize.
	self matchParent.
	self padding: (BlInsets top: 5 left: 5 bottom: 0 right: 5).
	self initializeContent.
	self phlow
		accessTool: (GtPhlowToolClassType forClass: GtLChat)
		viewModel: #chat
		object: #chat
]

{ #category : #initialization }
GtPhlowChatToolElement >> initializeContent [
	self addChild: self buildHeaderElement as: #header.
	self addChild: self buildViewsContainerElement as: #viewsContainer.
	self addChild: self buildPlaygroundPageElement as: #playgroundPage
]

{ #category : #private }
GtPhlowChatToolElement >> playgroundElement [
	^ self childNamed: #playgroundPage
]

{ #category : #private }
GtPhlowChatToolElement >> updateContainedViews [
	| compositeView tabGroup |
	self chat ifNil: [
		self viewsContainerElement removeChildren.
		^ self ].
	compositeView := GtPhlowCompositeView new
		views: self collectToolViews.
	tabGroup := compositeView asElementDo: [ :anElement | anElement ].
	self viewsContainerElement
		removeChildren;
		addChild: tabGroup
]

{ #category : #private }
GtPhlowChatToolElement >> updatePlayground [
	self chat ifNil: [ ^ self ].
	self playgroundElement
		objectHolder: (GtInspectorObject new
			object: self chat)
]

{ #category : #private }
GtPhlowChatToolElement >> viewsContainerElement [
	^ self childNamed: #viewsContainer
]
