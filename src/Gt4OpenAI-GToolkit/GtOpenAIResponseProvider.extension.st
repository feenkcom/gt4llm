Extension { #name : #GtOpenAIResponseProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIResponseProvider >> executeWait [
	[ | result |
	result := client
			generateResponseWithModel: self model
			messages: self chat messages
			instructions: instructions
			tools: tools
			andFormat: format.

	result hasToolCalls ifTrue: [ ^ self performToolCallsIn: result ].

	self chat
		addMessage: (self assistantMessageClass new merge: result output first).
		
	self chat signalRunIsDone.
	assistantWorking := false ]
		asAsyncPromise
]
