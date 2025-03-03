Extension { #name : #GtLlmFailureThreadMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmFailureThreadMessage >> elementClass [
	^ GtLlmThreadMessageElement
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmFailureThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
]
