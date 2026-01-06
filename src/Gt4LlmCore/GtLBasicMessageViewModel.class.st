Class {
	#name : #GtLBasicMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtLWithMessage + TGtAnnouncer',
	#classTraits : 'TGtLWithMessage classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'styler',
		'checkRunResultViewModels'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #accessing }
GtLBasicMessageViewModel class >> messageViewPragmas [
	^ #(gtLlmMessageView  gtLlmView)
]

{ #category : #visiting }
GtLBasicMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitBasicMessageViewModel: self
]

{ #category : #'as yet unclassified' }
GtLBasicMessageViewModel >> ancestor [
	^ self threadMessage ancestor
]

{ #category : #accessing }
GtLBasicMessageViewModel >> annotations [
	^ message ifNotNil: #annotations ifNil: [ #() ]
]

{ #category : #announcer }
GtLBasicMessageViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'api - converting' }
GtLBasicMessageViewModel >> asElement [
	^ self elementClass new messageViewModel: self
]

{ #category : #accessing }
GtLBasicMessageViewModel >> checkerInstance [
	^ message chat checkerInstance
]

{ #category : #accessing }
GtLBasicMessageViewModel >> codeBlocksExecutor [
	^ message codeBlocksExecutor
]

{ #category : #'api - converting' }
GtLBasicMessageViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #'private - hooks' }
GtLBasicMessageViewModel >> forwardAnnouncement: anAnnouncement [
		self announce: anAnnouncement
]

{ #category : #'gt - extensions' }
GtLBasicMessageViewModel >> gtMessageViewsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Message views';
		items: [ self messageViews ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'View' text: #yourself
]

{ #category : #accessing }
GtLBasicMessageViewModel >> id [
	^ message id
]

{ #category : #initialization }
GtLBasicMessageViewModel >> initialize [
	super initialize.
	checkRunResultViewModels := WeakIdentityKeyDictionary new
]

{ #category : #accessing }
GtLBasicMessageViewModel >> isAssistantRole [
	^ self threadMessage isAssistantRole
]

{ #category : #accessing }
GtLBasicMessageViewModel >> isUserRole [
	^ self threadMessage isUserRole
]

{ #category : #accessing }
GtLBasicMessageViewModel >> messageHeaderElement [
	^ GtLThreadMessageHeaderElement new messageViewModel: self
]

{ #category : #accessing }
GtLBasicMessageViewModel >> messageToolbarActions [
	^ GtPhlowActionsCollector new
		pragmaName: #gtLlmAction;
		fromObject: self message;
		collect
]

{ #category : #accessing }
GtLBasicMessageViewModel >> messageViewPragmas [
	^ self class messageViewPragmas
]

{ #category : #accessing }
GtLBasicMessageViewModel >> messageViews [
	| allViews |
	allViews := OrderedCollection
			streamContents: [ :aStream | 
				aStream
					nextPutAll: (GtPhlowViewsCollector new
							fromObject: self;
							pragmaNames: self messageViewPragmas;
							collect).

				self hasThreadMessage
					ifTrue: [ aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: self message;
									pragmaNames: self messageViewPragmas;
									collect).

						self message gtInspectorTargetModels
							do: [ :eachResponseModel | 
								aStream
									nextPutAll: (GtPhlowViewsCollector new
											fromObject: eachResponseModel;
											pragmaNames: self messageViewPragmas;
											collect) ] ] ].

	GtPhlowUtility sortByPriority: allViews.

	^ allViews
]

{ #category : #private }
GtLBasicMessageViewModel >> newStyler [
	^ BlCompositeStyler new
		stylers: {GtLlmMessageStyler new threadMessageViewModel: self.
				GtLlmThreadMessageStyler new annotations: self annotations}
]

{ #category : #'private - announcing' }
GtLBasicMessageViewModel >> notifyThreadMessageViewModelChanged [
	self announce: GtLlmThreadMessageViewModelChanged new
]

{ #category : #'private - announcement handling' }
GtLBasicMessageViewModel >> onAddMessageContents: anAnnouncement [
	self threadMessage chat announce: anAnnouncement
]

{ #category : #'private - hooks' }
GtLBasicMessageViewModel >> onMessageChanged [
	self notifyThreadMessageViewModelChanged
]

{ #category : #accessing }
GtLBasicMessageViewModel >> requestStyleSourceText [
	self announce: GtLlmThreadMessageRestyleRequested new
]

{ #category : #'as yet unclassified' }
GtLBasicMessageViewModel >> senderText [
	^ self message senderText
]

{ #category : #accessing }
GtLBasicMessageViewModel >> styler [
	^ styler ifNil: [ styler := self newStyler ]
]

{ #category : #'private - hooks' }
GtLBasicMessageViewModel >> subscribeToMessage [
	self message
		when: GtLlmMessageContentsUpdated
		send: #forwardAnnouncement:
		to: self
]

{ #category : #'as yet unclassified' }
GtLBasicMessageViewModel >> uiInsets [
	self message isAssistantRole ifTrue: [ ^ BlInsets right: 50 ].
	self message isToolRole ifTrue: [ ^ BlInsets left: 25 right: 25 ].
	^ BlInsets left: 50
]
