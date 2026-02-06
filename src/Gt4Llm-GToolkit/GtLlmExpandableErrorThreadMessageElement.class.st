Class {
	#name : #GtLlmExpandableErrorThreadMessageElement,
	#superclass : #GtLlmExpandableThreadMessageElement,
	#category : 'Gt4Llm-GToolkit-UI'
}

{ #category : #'as yet unclassified' }
GtLlmExpandableErrorThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := BrVerticalPane new matchParent
]

{ #category : #'as yet unclassified' }
GtLlmExpandableErrorThreadMessageElement >> onThreadMessageViewModelChanged [
	oneLineThreadMessageElement threadMessageViewModel: threadMessageViewModel.
	self updateThreadMessageElement.
	self expanded: threadMessageViewModel isExpanded.
	self margin: self margin + threadMessageViewModel uiInsets
]

{ #category : #'as yet unclassified' }
GtLlmExpandableErrorThreadMessageElement >> updateThreadMessageElement [
	threadMessageElement removeChildren
		addChild: self threadMessageViewModel messageHeaderElement;
		addChild: (BrDebuggableEditorElementStencil new
				freeze: self threadMessageViewModel threadMessage exception;
				asElement)
]
