Extension { #name : #GtOpenAIResponseProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIResponseProvider >> executeWait [
	executions
		add: ([ | result aMessage |
			result := client
					generateResponseWithModel: self model
					messages: self chat messages
					instructions: instructions
					tools: tools
					andFormat: format.

			aMessage := format
					ifNil: [ self streamingMessageFrom: result ]
					ifNotNil: [ result hasToolCalls ifTrue: [ ^ self performToolCallsIn: result ].
						self assistantMessageClass new
							merge: (result output detect: [ :anOutput | (anOutput rawData at: 'type') = 'message' ]) ].


			self chat addMessage: aMessage.

			self chat signalRunIsDone.
			assistantWorking := false ] asAsyncFuture
				await: GtOpenAIUtilities executionConfiguration)
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
