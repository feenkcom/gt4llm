Extension { #name : #GtOpenAIResponseProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIResponseProvider >> executeWait [
	executions
		add: (([ | result aMessage |
			result := client
					generateResponseWithModel: self model
					messages: self chat messages
					instructions: instructions
					tools: tools
					andFormat: format.

			result hasToolCalls
				ifTrue: [ self performToolCallsIn: result ]
				ifFalse: [ aMessage := format
							ifNil: [ self streamingMessageFrom: result ]
							ifNotNil: [ self assistantMessageClass new
									model: self model;
									merge: (result output detect: [ :anOutput | (anOutput rawData at: 'type') = 'message' ]) ].


					self chat addMessage: aMessage.
					self chat signalRunIsDone ] ] asAsyncFuture
				await: GtOpenAIUtilities executionConfiguration)
				then: [ assistantWorking := false ]
				otherwise: [ :anError | 
					assistantWorking := false.
					self chat
						addMessage: (GtLlmErrorThreadMessage new exception: anError freeze).
					self chat signalRunIsDone ])
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIResponseProvider >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instructions';
		priority: 5;
		text: [ self instructions ifNil: [ '' ] ];
		actionButtonIcon: #BrGlamorousVectorIcons asClass accept
			tooltip: 'Save instructions'
			action: [ :aButton | 
				aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | self instructions: anEditor text asString ] ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIResponseProvider >> streamingMessageFrom: aResult [
	| aMessage |
	aResult provider: self.

	aMessage := self assistantMessageClass new
			role: 'assistant';
			model: self model;
			content: ''.
	aResult notifyOnOutput: aMessage.

	^ aMessage
]
