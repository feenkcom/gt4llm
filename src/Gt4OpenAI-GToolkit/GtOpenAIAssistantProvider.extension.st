Extension { #name : #GtOpenAIAssistantProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIAssistantProvider >> executeWait [
	future := (self runFuture
			then: [ :aRun | 
				self updateMessages.
				chat signalRunIsDone ]) await: GtOpenAIUtilities executionConfiguration
]
