Extension { #name : #GtSearchFilter }

{ #category : #'*Gt4LlmCore' }
GtSearchFilter >> llmResultDataViewsFor: aDataView [
	<gtLlmDataView>
	^ aDataView forwardObject
		title: 'Results';
		object: [ self result ]
]
