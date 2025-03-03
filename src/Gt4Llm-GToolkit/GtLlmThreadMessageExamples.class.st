Class {
	#name : #GtLlmThreadMessageExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmThreadMessageExamples >> basicExpandableThreadMessageElement [
	<gtExample>
	| anElement |
	anElement := GtLlmExpandableThreadMessageElement new.

	self assert: anElement threadMessageViewModel isNil.

	^ anElement
]

{ #category : #'as yet unclassified' }
GtLlmThreadMessageExamples >> basicFailureThreadMessage [
	<gtExample>
	| aMessage |
	aMessage := GtLlmFailureThreadMessage new createdAt: DateAndTime now.

	self assert: aMessage failureText isNil.
	self assert: aMessage contentText isNotNil.
	self assert: aMessage contentText isEmpty.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtLlmThreadMessageExamples >> basicThreadMessageViewModel [
	<gtExample>
	| aViewModel |
	aViewModel := GtLlmThreadMessageViewModel new.

	self assert: aViewModel threadMessage isNil.

	^ aViewModel
]

{ #category : #'as yet unclassified' }
GtLlmThreadMessageExamples >> failureThreadMessage [
	<gtExample>
	| aMessage aDescription |
	aMessage := self basicFailureThreadMessage.
	aDescription := 'Sorry, something went wrong'.
	aMessage failureText: aDescription.
	
	self assert: aMessage failureText isNotNil.
	self assert: aMessage contentText isNotNil.
	self assert: aMessage contentText equals: aDescription.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtLlmThreadMessageExamples >> failureThreadMessageElement [
	<gtExample>
	| aViewModel anElement |
	
	aViewModel := self failureThreadMessageViewModel.
	anElement := aViewModel elementClass newForChatList.
	anElement threadMessageViewModel: aViewModel.

	self assert: anElement threadMessageViewModel equals: aViewModel.

	^ anElement
]

{ #category : #'as yet unclassified' }
GtLlmThreadMessageExamples >> failureThreadMessageViewModel [
	<gtExample>
	| aMessage aViewModel |
	
	aViewModel := self basicThreadMessageViewModel.
	aMessage := self failureThreadMessage.
	aViewModel threadMessage: aMessage.

	self assert: aViewModel threadMessage equals: aMessage.	
	self assert: aViewModel contentText isNotNil.
	self assert: aMessage contentText equals: aMessage contentText.
	self assert: aViewModel isFailure.

	^ aViewModel
]
