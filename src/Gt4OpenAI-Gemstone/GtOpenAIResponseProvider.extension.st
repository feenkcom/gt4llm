Extension { #name : #GtOpenAIResponseProvider }

{ #category : #'*Gt4OpenAI-Gemstone' }
GtOpenAIResponseProvider >> executeWait [
	| result aMessage |
	result := client
		generateResponseWithModel: self model
		messages: self chat messages
		instructions: instructions
		tools: tools
		andFormat: format.

	result hasToolCalls
		ifTrue: [ ^ self performToolCallsIn: result ].
	aMessage := self assistantMessageClass new merge: result output first.


	self chat addMessage: aMessage.

	self chat signalRunIsDone.
	assistantWorking := false
]
