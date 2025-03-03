Extension { #name : #GtLlmValueHolder }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmValueHolder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ (content gtViewsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | 
					e
						margin: (BlInsets all: 15);
						background: Color white;
						addAptitude: BrShadowAptitude ] ]
]
