"
I render the list of tools used while producing a reply message.

## Example
{{gtExample:GtLChatOpenAIElementExamples>>#messageUsedToolsElement|noCode|previewExpanded}}
"
Class {
	#name : #GtLMessageUsedToolsElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'listElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLMessageUsedToolsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtLMessageUsedToolsElement >> initialize [
	super initialize.
	
	self initializeListElement.
	
	self addChild: listElement.
	
	self addAptitude: (BrLayoutResizerAptitude new common: listElement).
		
	self
		hMatchParent;
		vFitContentLimited.
]

{ #category : #initialization }
GtLMessageUsedToolsElement >> initializeListElement [
	listElement := BrSimpleList new
			hMatchParent;
			vFitContent;
			beFocusable;
			addEventHandler: (GtPhlowListToSelectHandler new
					transformation: [ :aViewModel | aViewModel message ]);
			itemStencil: [ :anItemType :aListWidget | self newListItemElement ];
			itemDataBinder: [ :anItemElement :anItemObject :anItemIndex | 
				anItemElement messageViewModel: anItemObject.
				anItemElement ]
]

{ #category : #initialization }
GtLMessageUsedToolsElement >> newListItemElement [
	^ GtMessageOneLineMultiLabelSummaryElement new
		addAptitude: BrGlamorousListItemAptitude;
		hMatchParent;
		vFitContent
]

{ #category : #'private - hooks' }
GtLMessageUsedToolsElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.
	self updateElement
]

{ #category : #'as yet unclassified' }
GtLMessageUsedToolsElement >> updateElement [
	listElement stream: self messageViewModel executionMessageViewModelsStream
]
