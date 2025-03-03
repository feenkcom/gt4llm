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
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: self asViewModel ]
]
