Extension { #name : #GtOpenAIResponseProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIResponseProvider >> executeWait [
	[ | result aMessage |
	result := client
			generateResponseWithModel: self model
			messages: self chat messages
			instructions: instructions
			tools: tools
			andFormat: format.

	aMessage := format
			ifNil: [ self streamingMessageFrom: result ]
			ifNotNil: [ result hasToolCalls ifTrue: [ ^ self performToolCallsIn: result ].
				self assistantMessageClass new merge: result output first ].


	self chat addMessage: aMessage.

	self chat signalRunIsDone.
	assistantWorking := false ] asAsyncPromise
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIResponseProvider >> streamingMessageFrom: aResult [
	| aMessage |
	aResult provider: self.

	aMessage := self assistantMessageClass new
			role: 'assistant';
			content: ''.
	aResult notifyOnOutput: aMessage.

	^ aMessage
]
