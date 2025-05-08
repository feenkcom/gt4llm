Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> asViewModel [
	^ GtLlmThreadMessageViewModel new threadMessage: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new hideHeaderElement
				threadMessageViewModel: self asViewModel ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> gtJsonFor: aView [
	<gtView>
	<gtLlmMessageView>
	[ self contentJson ] on: Error do: [ ^ aView empty ].

	^ (self contentJson gtTreeFor: aView)
		title: 'JSON data';
		priority: 4.5
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> uuidClass [
	^ UUID
]
