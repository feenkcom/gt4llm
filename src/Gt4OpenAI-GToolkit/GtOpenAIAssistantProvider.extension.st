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
GtOpenAIAssistantProvider >> registerForFinalization [
	self class finalizationRegistry add: self
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIAssistantProvider >> runFuture [
	^ GtLlmThreadRunFuture new chat: self
]
