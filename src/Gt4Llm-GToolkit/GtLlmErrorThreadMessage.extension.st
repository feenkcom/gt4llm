Extension { #name : #GtLlmErrorThreadMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmErrorThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Error';
		priority: 1;
		stencil: [ exception asDebuggableElement ]
]
