Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtLlmChatMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	| json |
	[ json := self contentJson ] on: Error do: [ ^ aView empty ].

	json at: 'Text' ifAbsent: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 1;
		text: [ json at: 'Text' ];
		styler: [ GtLlmMessageStyler new threadMessageViewModel: self asViewModel ]
]
