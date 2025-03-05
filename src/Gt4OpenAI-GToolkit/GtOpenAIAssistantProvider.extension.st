Extension { #name : #GtOpenAIAssistantProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIAssistantProvider >> executeWait [
	future := (self runFuture
			then: [ :aRun | 
				self updateMessages.
				chat signalRunIsDone ]) await: GtOpenAIUtilities executionConfiguration
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIAssistantProvider >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instructions';
		priority: 1;
		text: [ self instructions ];
		styler: GtLlmMessageStyler new
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIAssistantProvider >> registerForFinalization [
	self class finalizationRegistry add: self
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIAssistantProvider >> runFuture [
	^ GtLlmThreadRunFuture new chat: self
]
