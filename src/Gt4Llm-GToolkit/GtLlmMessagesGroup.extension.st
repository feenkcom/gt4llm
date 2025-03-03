Extension { #name : #GtLlmMessagesGroup }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmMessagesGroup >> gtJsonFor: aView [
	<gtView>
	^ aView textEditor
		title: 'JSON';
		priority: 1;
		text: [ self asJson ];
		styler: JSONParser gtStyler
]
