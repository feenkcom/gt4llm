Extension { #name : #GtLlmGroup }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmGroup >> asAsyncStream [
	^ AsyncSequenceStream forCollection: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmGroup >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]
