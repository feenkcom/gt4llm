Extension { #name : #GtOllamaProvider }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> asyncWait [
	executions
		add: ([ self triggerAssistant ] asAsyncPromise
				then: [  ]
				otherwise: [ :anError | 
					assistantWorking := false.
					self chat
						addMessage: (GtLlmErrorThreadMessage new exception: anError freeze).
					self chat signalRunIsDone ])
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider class >> gtToggleEnabledActionFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: (IsConnectable ifTrue: [ 'Disable' ] ifFalse: [ 'Enable' ]);
		icon: BrGlamorousVectorIcons shutdown;
		action: [ :aButton | IsConnectable := IsConnectable not ]
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider class >> isConnectable [
	^ IsConnectable
]
