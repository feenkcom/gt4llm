Extension { #name : #GtLlmProvisionalThreadMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmProvisionalThreadMessage >> elementClass [
	^ GtLlmThreadMessageElement
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmProvisionalThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
]
