Extension { #name : #GtOpenAIFile }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIFile >> gtFileFor: aView [
	<gtView>
	^ aView explicit
		title: 'File';
		priority: 1;
		stencil: [ (self contents gtViewsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | 
					e
						margin: (BlInsets all: 15);
						background: Color white;
						addAptitude: BrShadowAptitude ] ]
]
