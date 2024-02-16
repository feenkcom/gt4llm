Class {
	#name : #GtLlmCheckRunExecutionPreviewElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLlmWithCheckRunResultViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLlmWithCheckRunResultViewModel classTrait',
	#instVars : [
		'contentsElement',
		'createMessageElement'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #convenience }
GtLlmCheckRunExecutionPreviewElement >> checkRunResult: aResult [
	self
		checkRunResultViewModel: (GtLlmCheckRunResultViewModel new checkRunResult: aResult)
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionPreviewElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionPreviewElement >> initialize [
	super initialize.

	self initializeContentsElement.
	self initializeCreateMessageElement.

	self addChild: contentsElement as: #contents.
	self addChild: createMessageElement as: #send.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionPreviewElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionPreviewElement >> initializeCreateMessageElement [
	createMessageElement := BrButton new
			fitContent;
			addAptitude: BrGlamorousButtonWithLabelAptitude new;
			label: 'Create message';
			action: [ :anEvent | self onCreateMessageEvent: anEvent ];
			beSmallSize
]

{ #category : #'private - hooks' }
GtLlmCheckRunExecutionPreviewElement >> onCheckRunResultViewModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtLlmCheckRunExecutionPreviewElement >> onCreateMessageEvent: anEvent [
	checkRunResultViewModel addToNewMessage
]

{ #category : #'private - updating' }
GtLlmCheckRunExecutionPreviewElement >> updateContentsElement [
	contentsElement text: checkRunResultViewModel messageContents
]

{ #category : #'private - updating' }
GtLlmCheckRunExecutionPreviewElement >> updateElement [
	self updateContentsElement
]
