Extension { #name : #GtOllamaThreadMessage }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new
						threadMessage: GtLlmNewThreadMessage new))
]
