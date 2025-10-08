Class {
	#name : #GtLlmChatExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmChatExamples >> basicChat [
	<gtExample>
	| chat |
	chat :=  GtLlmChat new.
	
	self assert: chat messages size equals: 0.
	self assert: chat status isDone not.
	self assert: chat hasProvider not.
	
	^ chat
]

{ #category : #accessing }
GtLlmChatExamples >> chatFuture [
	<gtExample>
	| chat ran |
	chat := self basicChat.

	chat provider: GtLlmNullProvider new.
	
	ran := false.
	
	(chat whenReadyFuture then: [ran := true]) wait.
	
	self assert: ran.
	
	^ chat
]

{ #category : #accessing }
GtLlmChatExamples >> chatWithMessages [
	<gtExample>
	| chat |
	chat := self chatWithProvider.

	chat sendMessage: 'Hi!'.
	
	self assert: chat status isDone.
	self assert: chat messages size equals: 1.
	
	^ chat
]

{ #category : #accessing }
GtLlmChatExamples >> chatWithProvider [
	<gtExample>
	| chat |
	chat := self basicChat.

	chat provider: GtLlmNullProvider new.

	self assert: chat provider class equals: GtLlmNullProvider.
	self assert: chat status isDone.

	^ chat
]
