Class {
	#name : #GtLlmExpandableThreadMessageElement,
	#superclass : #BrExpander,
	#traits : 'TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TGtLlmWithThreadMessageViewModel classTrait',
	#instVars : [
		'oneLineThreadMessageElement',
		'threadMessageElement'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #factory }
GtLlmExpandableThreadMessageElement class >> newForChatList [
	^ self new
		margin: (BlInsets
				top: 3
				bottom: 12
				left: 5
				right: 10);
		collapse
]

{ #category : #'initialization ' }
GtLlmExpandableThreadMessageElement >> initialize [
	super initialize.

	self initializeOneLineThreadMessageElement.
	self initializeThreadMessageElement.

	self
		addAptitude: GtCoderExpanderAptitude new;
		header: [ oneLineThreadMessageElement ];
		content: [ threadMessageElement ].

	self states withExpansion.
	self whenExpandedDo: [ self onExpanded ].
	self whenCollapsedDo: [ self onCollapsed ].
	self expand.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLlmExpandableThreadMessageElement >> initializeOneLineThreadMessageElement [
	"oneLineThreadMessageElement := GtLlmThreadMessageElement new
			contentsAptitudeDo: [ :anAptitude | 
				anAptitude foreground: BrGlamorousColors disabledButtonTextColor ]"
	oneLineThreadMessageElement := GtLlmThreadMessageHeaderElement new.
]

{ #category : #'initialization ' }
GtLlmExpandableThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtLlmThreadMessageContentHolder new
]

{ #category : #'initialization ' }
GtLlmExpandableThreadMessageElement >> onCollapsed [
	threadMessageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: false ]
]

{ #category : #'private - event handling' }
GtLlmExpandableThreadMessageElement >> onExpanded [
	threadMessageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: true ]
]

{ #category : #'private - hooks' }
GtLlmExpandableThreadMessageElement >> onThreadMessageViewModelChanged [
	oneLineThreadMessageElement
		threadMessageViewModel: threadMessageViewModel.
	threadMessageElement threadMessageViewModel: threadMessageViewModel.
	self expanded: threadMessageViewModel isExpanded
]

{ #category : #accessing }
GtLlmExpandableThreadMessageElement >> threadMessageElement [
	^ threadMessageElement asElement
]
