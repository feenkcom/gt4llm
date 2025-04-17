Class {
	#name : #GtLlmBasicThreadMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithThreadMessage + TGtAnnouncer',
	#classTraits : 'TGtLlmWithThreadMessage classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'styler',
		'checkRunResultViewModels'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel class >> messageViewPragmas [
	^ #(#gtLlmMessageView)
]

{ #category : #'as yet unclassified' }
GtLlmBasicThreadMessageViewModel >> ancestor [
	^ self threadMessage ancestor
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> annotations [
	^ threadMessage ifNotNil: #annotations ifNil: [ #() ]
]

{ #category : #announcer }
GtLlmBasicThreadMessageViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> checkerInstance [
	^ threadMessage chat checkerInstance
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> codeBlocksExecutor [
	^ threadMessage codeBlocksExecutor
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #'private - hooks' }
GtLlmBasicThreadMessageViewModel >> forwardAnnouncement: anAnnouncement [
		self announce: anAnnouncement
]

{ #category : #'gt - extensions' }
GtLlmBasicThreadMessageViewModel >> gtMessageViewsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Message views';
		items: [ self messageViews ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'Viw' text: #yourself
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> id [
	^ threadMessage id
]

{ #category : #initialization }
GtLlmBasicThreadMessageViewModel >> initialize [
	super initialize.
	checkRunResultViewModels := WeakIdentityKeyDictionary new
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> isAssistantRole [
	^ self threadMessage isAssistantRole
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> messageHeaderElement [
	^ GtLlmThreadMessageHeaderElement new threadMessageViewModel: self
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> messageToolbarActions [
	^ GtPhlowActionsCollector new
		pragmaName: #gtLlmAction;
		fromObject: self threadMessage;
		collect
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> messageViewPragmas [
	^ self class messageViewPragmas
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> messageViews [
	^ GtPhlowViewsCollector new
		fromObject: self threadMessage;
		pragmaNames: self messageViewPragmas;
		collect
]

{ #category : #private }
GtLlmBasicThreadMessageViewModel >> newStyler [
	^ BlCompositeStyler new
		stylers: {GtLlmMessageStyler new threadMessageViewModel: self.
				GtLlmThreadMessageStyler new annotations: self annotations}
]

{ #category : #'private - announcing' }
GtLlmBasicThreadMessageViewModel >> notifyThreadMessageViewModelChanged [
	self announce: GtLlmThreadMessageViewModelChanged new
]

{ #category : #'private - announcement handling' }
GtLlmBasicThreadMessageViewModel >> onAddMessageContents: anAnnouncement [
	self threadMessage chat announce: anAnnouncement
]

{ #category : #'private - hooks' }
GtLlmBasicThreadMessageViewModel >> onThreadMessageChanged [
	self notifyThreadMessageViewModelChanged
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> requestStyleSourceText [
	self announce: GtLlmThreadMessageRestyleRequested new
]

{ #category : #'as yet unclassified' }
GtLlmBasicThreadMessageViewModel >> senderText [
	^ self threadMessage senderText
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> styler [
	^ styler ifNil: [ styler := self newStyler ]
]

{ #category : #'private - hooks' }
GtLlmBasicThreadMessageViewModel >> subscribeToThreadMessage [
	self threadMessage
		when: GtLlmMessageContentsUpdated
		send: #forwardAnnouncement:
		to: self
]

{ #category : #'as yet unclassified' }
GtLlmBasicThreadMessageViewModel >> uiInsets [
	self threadMessage isAssistantRole ifTrue: [ ^ BlInsets right: 50 ].
	^ BlInsets left: 50
]
