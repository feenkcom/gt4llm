Extension { #name : #GtLlmChatExamples }

{ #category : #'*Gt4Llm-GToolkit' }
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
