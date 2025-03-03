Extension { #name : #GtLlmSerializableValueHolder }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmSerializableValueHolder >> gtSerializedFor: aView [
	<gtView>
	^ aView explicit
		title: 'Serialized';
		priority: 2;
		stencil: [ (self contentValue gtViewsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | 
					e
						margin: (BlInsets all: 15);
						background: Color white;
						addAptitude: BrShadowAptitude ] ]
]
