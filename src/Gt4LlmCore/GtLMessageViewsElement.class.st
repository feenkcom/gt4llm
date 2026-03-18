"
I render the computed views of a chat message content.

## Example
{{gtExample:GtLChatOpenAIElementExamples>>#messageViewsElement|noCode|previewExpanded}}
"
Class {
	#name : #GtLMessageViewsElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'viewUpdater'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #'private - updating' }
GtLMessageViewsElement >> computeViewsElement [
	<return: #BlElement or: nil>
	| someViews |
	someViews := Array
			streamContents: [ :aStream | 
				self messageViewModel messageViews
					do: [ :aView | aView ifItHasContent: [ aStream nextPut: aView ] ] ].
	someViews ifEmpty: [ ^ nil ].
	^ GtPhlowCompositeView new
			views: someViews;
			asElementDo: [ :e | e vFitContentLimited ].
]

{ #category : #initialization }
GtLMessageViewsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtLMessageViewsElement >> initialize [
	super initialize.

	self initializeViewUpdater.

	self asyncFuture
		executionConfiguration: GtLSettings futureUIExecutionConfiguration;
		whenPending: [ :anElement |  ];
		whenError: [ :anElement :anException | self onException: anException ];
		whenSuccess: [ :anElement :anElementOrNil | self onViewsReady: anElementOrNil ].

	self addAptitude: (BrLayoutResizerAptitude new common: [ self children ]).
		
	self
		hMatchParent;
		vFitContentLimited
]

{ #category : #initialization }
GtLMessageViewsElement >> initializeViewUpdater [
	viewUpdater := BrElementUpdater new.
	viewUpdater element: self selector: #updateViews.
	viewUpdater postponedDuration: 300 milliseconds
]

{ #category : #'private - event handling' }
GtLMessageViewsElement >> onException: anException [
	| anElement |
	anElement := anException asDebuggableElement
			vFitContentLimited;
			hMatchParent.
	self onViewsReady: anElement
]

{ #category : #'private - event handling' }
GtLMessageViewsElement >> onMessageContentsUpdated: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ viewUpdater requestUpdate ]
]

{ #category : #'private - hooks' }
GtLMessageViewsElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtLMessageViewsElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtLMessageViewsElement >> onViewsReady: anElementOrNil [
	self removeChildNamed: #'message-tabs'.
	anElementOrNil ifNil: [ ^ self ].
	self addChild: anElementOrNil as: #'message-tabs'
]

{ #category : #'private - hooks' }
GtLMessageViewsElement >> subscribeToMessageViewModel [
	super subscribeToMessageViewModel.
	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLMessageViewModelContentsChanged
			send: #onMessageContentsUpdated:
			to: self
]

{ #category : #'private - hooks' }
GtLMessageViewsElement >> unsubscribeFromMessageViewModel [
	super unsubscribeFromMessageViewModel.
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLMessageViewsElement >> updateElement [
	self updateViews
]

{ #category : #'private - updating' }
GtLMessageViewsElement >> updateViews [
	"Called by updater"

	self asyncFuture future: [ self computeViewsElement ] asAsyncFuture
]
