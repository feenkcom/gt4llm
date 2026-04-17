Class {
	#name : #GtSmaCCRewriteMatchSpecification,
	#superclass : #Object,
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #converting }
GtSmaCCRewriteMatchSpecification >> asSmaCCMatch [
	self subclassResponsibility
]

{ #category : #accessing }
GtSmaCCRewriteMatchSpecification >> errorMessage [
	^ nil
]

{ #category : #'llm views' }
GtSmaCCRewriteMatchSpecification >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]
