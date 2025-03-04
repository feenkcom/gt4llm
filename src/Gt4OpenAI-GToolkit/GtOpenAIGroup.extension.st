Extension { #name : #GtOpenAIGroup }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIGroup >> asAsyncStream [
	^ AsyncSequenceStream forCollection: self
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIGroup >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]
