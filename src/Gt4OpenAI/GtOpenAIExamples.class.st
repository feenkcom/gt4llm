Class {
	#name : #GtOpenAIExamples,
	#superclass : #Object,
	#category : #'Gt4OpenAI-Examples'
}

{ #category : #'examples - failure message' }
GtOpenAIExamples >> basicFailureThreadMessage [
	<gtExample>
	| aMessage |
	aMessage := GtOpenAIFailureThreadMessage new.

	self assert: aMessage failureText isNil.
	self assert: aMessage contentText isNotNil.
	self assert: aMessage contentText isEmpty.

	^ aMessage
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> basicThreadMessageViewModel [
	<gtExample>
	| aViewModel |
	aViewModel := GtOpenAIThreadMessageViewModel new.

	self assert: aViewModel threadMessage isNil.

	^ aViewModel
]

{ #category : #'examples - failure message' }
GtOpenAIExamples >> failureThreadMessage [
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

{ #category : #'examples - failure message' }
GtOpenAIExamples >> failureThreadMessageElement [
	<gtExample>
	| aViewModel anElement |
	
	aViewModel := self failureThreadMessageViewModel.
	anElement := aViewModel elementClass newForChatList.
	anElement threadMessageViewModel: aViewModel.

	self assert: anElement threadMessageViewModel equals: aViewModel.

	^ anElement
]

{ #category : #'examples - failure message' }
GtOpenAIExamples >> failureThreadMessageViewModel [
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
