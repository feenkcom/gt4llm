Class {
	#name : #GtLlmCheckRunExecutionErrorElement,
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
GtLlmCheckRunExecutionErrorElement >> checkRunResult: aResult [
	self
		checkRunResultViewModel: (GtLlmCheckRunResultViewModel new checkRunResult: aResult)
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionErrorElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionErrorElement >> initialize [
	super initialize.

	self initializeContentsElement.
	self initializeCreateMessageElement.

	self addChild: contentsElement as: #contents.
	self addChild: createMessageElement as: #send.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionErrorElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #'initialization ' }
GtLlmCheckRunExecutionErrorElement >> initializeCreateMessageElement [
	createMessageElement := BrButton new
			fitContent;
			addAptitude: BrGlamorousButtonWithLabelAptitude new;
			label: 'Create message';
			action: [ :anEvent | self onCreateMessageEvent: anEvent ];
			beSmallSize
]

{ #category : #'private - hooks' }
GtLlmCheckRunExecutionErrorElement >> onCheckRunResultViewModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtLlmCheckRunExecutionErrorElement >> onCreateMessageEvent: anEvent [
	checkRunResultViewModel sendToChat
]

{ #category : #'private - updating' }
GtLlmCheckRunExecutionErrorElement >> updateContentsElement [
	contentsElement text: checkRunResultViewModel executionResult asString
]

{ #category : #'private - updating' }
GtLlmCheckRunExecutionErrorElement >> updateElement [
	self updateContentsElement
]
