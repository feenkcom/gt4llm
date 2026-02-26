Class {
	#name : #GtLActionToolbarMessageElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'toolbarElement',
		'toolbarUpdater'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLActionToolbarMessageElement >> defaultLayout [
	^ BlLinearLayout horizontal.
]

{ #category : #initialization }
GtLActionToolbarMessageElement >> initialize [
	super initialize.
	self fitContent.

	self initializeToolbarElement.
	self addAptitude: (BrLayoutResizerAptitude new common: toolbarElement).
	self addChild: toolbarElement
]

{ #category : #initialization }
GtLActionToolbarMessageElement >> initializeToolbarElement [
	toolbarElement := BrToolbar new aptitude: BrGlamorousToolbarAptitude new.
	
	toolbarUpdater := BrElementUpdater new.
	toolbarUpdater element: self selector: #updateToolbarElement.
	toolbarUpdater postponedDuration: 300 milliseconds
]

{ #category : #'private - event handling' }
GtLActionToolbarMessageElement >> onMessageContentsUpdated: anAnnouncement [
	anAnnouncement messageViewModel = self messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ toolbarUpdater requestUpdate ]
]

{ #category : #'private - hooks' }
GtLActionToolbarMessageElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.

	self updateElement
]

{ #category : #'private - event handling' }
GtLActionToolbarMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ toolbarUpdater requestUpdate ]
]

{ #category : #'private - hooks' }
GtLActionToolbarMessageElement >> subscribeToMessageViewModel [
	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLMessageViewModelContentsChanged
			send: #onMessageContentsUpdated:
			to: self
]

{ #category : #'private - hooks' }
GtLActionToolbarMessageElement >> unsubscribeFromMessageViewModel [
	self messageViewModel unsubscribe: self
]

{ #category : #'private - hooks' }
GtLActionToolbarMessageElement >> updateElement [
	self updateToolbarElement
]

{ #category : #'private - hooks' }
GtLActionToolbarMessageElement >> updateToolbarElement [
	toolbarElement removeAllItems.
	self messageViewModel messageToolbarActions
		do: [ :each | 
			each
				asElement: [ :actionElement | 
					actionElement states addState: BrSizeAdjustmentState tiny.
					toolbarElement addItem: actionElement ]
				withHostElement: self ]
]
