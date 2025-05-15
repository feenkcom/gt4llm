Extension { #name : #GtLlmNewThreadMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmNewThreadMessage >> asViewModel [
	^ GtLlmNewThreadMessageViewModel new threadMessage: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmNewThreadMessage >> elementClass [
	^ GtLlmNewThreadMessageElement
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmNewThreadMessage >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 1;
		stencil: [ self asViewModel asElement
				margin: (BlInsets all: 10);
				background: Color white;
				addAptitude: BrShadowAptitude new ]
]
