Class {
	#name : #GtLBasicMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'styler',
		'checkRunResultViewModels'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #accessing }
GtLBasicMessageViewModel class >> messageViewPragmas [
	^ GtLSettings messageViewPragmaNames
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
	^ SmallDictionary new
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
	"Return a unique id that identifies this message"

	^ self subclassResponsibility
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
GtLBasicMessageViewModel >> messageHeaderElement [
	^ GtLMessageHeaderElement new messageViewModel: self
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
			streamContents: [ :aStream | self messageViewsInto: aStream ].

	GtPhlowUtility sortByPriority: allViews.

	^ allViews
]

{ #category : #accessing }
GtLBasicMessageViewModel >> messageViewsInto: aStream [
	aStream
		nextPutAll: (GtPhlowViewsCollector new
				fromObject: self;
				pragmaNames: self messageViewPragmas;
				collect).

	self hasMessage
		ifTrue: [ aStream
				nextPutAll: (GtPhlowViewsCollector new
						fromObject: self message currentMessage;
						pragmaNames: self messageViewPragmas;
						collect).

			self message currentMessage gtInspectorTargetModels
				do: [ :eachResponseModel | 
					aStream
						nextPutAll: (GtPhlowViewsCollector new
								fromObject: eachResponseModel;
								pragmaNames: self messageViewPragmas;
								collect) ] ]
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

{ #category : #'api - accessing' }
GtLBasicMessageViewModel >> uiInsets [
	^ BlInsets left: 50
]
