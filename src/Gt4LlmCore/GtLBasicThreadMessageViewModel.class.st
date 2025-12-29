Class {
	#name : #GtLBasicThreadMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithThreadMessage + TGtAnnouncer',
	#classTraits : 'TGtLlmWithThreadMessage classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'styler',
		'checkRunResultViewModels'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLBasicThreadMessageViewModel class >> messageViewPragmas [
	^ #(gtLlmMessageView  gtLlmView)
]

{ #category : #'as yet unclassified' }
GtLBasicThreadMessageViewModel >> ancestor [
	^ self threadMessage ancestor
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> annotations [
	^ threadMessage ifNotNil: #annotations ifNil: [ #() ]
]

{ #category : #announcer }
GtLBasicThreadMessageViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'as yet unclassified' }
GtLBasicThreadMessageViewModel >> asElement [
	^ self elementClass new threadMessageViewModel: self
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> checkerInstance [
	^ threadMessage chat checkerInstance
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> codeBlocksExecutor [
	^ threadMessage codeBlocksExecutor
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #'private - hooks' }
GtLBasicThreadMessageViewModel >> forwardAnnouncement: anAnnouncement [
		self announce: anAnnouncement
]

{ #category : #'gt - extensions' }
GtLBasicThreadMessageViewModel >> gtMessageViewsFor: aView [
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
GtLBasicThreadMessageViewModel >> id [
	^ threadMessage id
]

{ #category : #initialization }
GtLBasicThreadMessageViewModel >> initialize [
	super initialize.
	checkRunResultViewModels := WeakIdentityKeyDictionary new
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> isAssistantRole [
	^ self threadMessage isAssistantRole
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> isUserRole [
	^ self threadMessage isUserRole
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> messageHeaderElement [
	^ GtLThreadMessageHeaderElement new threadMessageViewModel: self
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> messageToolbarActions [
	^ GtPhlowActionsCollector new
		pragmaName: #gtLlmAction;
		fromObject: self threadMessage;
		collect
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> messageViewPragmas [
	^ self class messageViewPragmas
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> messageViews [
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
									fromObject: self threadMessage;
									pragmaNames: self messageViewPragmas;
									collect).

						self threadMessage gtInspectorTargetModels
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
GtLBasicThreadMessageViewModel >> newStyler [
	^ BlCompositeStyler new
		stylers: {GtLlmMessageStyler new threadMessageViewModel: self.
				GtLlmThreadMessageStyler new annotations: self annotations}
]

{ #category : #'private - announcing' }
GtLBasicThreadMessageViewModel >> notifyThreadMessageViewModelChanged [
	self announce: GtLlmThreadMessageViewModelChanged new
]

{ #category : #'private - announcement handling' }
GtLBasicThreadMessageViewModel >> onAddMessageContents: anAnnouncement [
	self threadMessage chat announce: anAnnouncement
]

{ #category : #'private - hooks' }
GtLBasicThreadMessageViewModel >> onThreadMessageChanged [
	self notifyThreadMessageViewModelChanged
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> requestStyleSourceText [
	self announce: GtLlmThreadMessageRestyleRequested new
]

{ #category : #'as yet unclassified' }
GtLBasicThreadMessageViewModel >> senderText [
	^ self threadMessage senderText
]

{ #category : #accessing }
GtLBasicThreadMessageViewModel >> styler [
	^ styler ifNil: [ styler := self newStyler ]
]

{ #category : #'private - hooks' }
GtLBasicThreadMessageViewModel >> subscribeToThreadMessage [
	self threadMessage
		when: GtLlmMessageContentsUpdated
		send: #forwardAnnouncement:
		to: self
]

{ #category : #'as yet unclassified' }
GtLBasicThreadMessageViewModel >> uiInsets [
	self threadMessage isAssistantRole ifTrue: [ ^ BlInsets right: 50 ].
	self threadMessage isToolRole ifTrue: [ ^ BlInsets left: 25 right: 25 ].
	^ BlInsets left: 50
]
