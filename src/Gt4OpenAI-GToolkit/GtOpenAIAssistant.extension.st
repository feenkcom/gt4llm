Extension { #name : #GtOpenAIAssistant }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIAssistant >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Tutor instructions';
		priority: 5;
		text: [ self instructions ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new))
]
