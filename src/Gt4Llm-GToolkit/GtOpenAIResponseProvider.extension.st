Extension { #name : #GtOpenAIResponseProvider }

{ #category : #'*Gt4Llm-GToolkit' }
GtOpenAIResponseProvider >> executeWait [
	[ | result |
	result := client
			generateResponseWithModel: self model
			messages: self chat messages
			instructions: instructions
			tools: tools
			andFormat: format.

	result hasToolCalls
		ifTrue: [ self chat signalRunHasUpdated.
			^ self performToolCallsIn: result ].

	self chat
		addMessage: (self assistantMessageClass new merge: result output first) ]
		asAsyncPromise
]
