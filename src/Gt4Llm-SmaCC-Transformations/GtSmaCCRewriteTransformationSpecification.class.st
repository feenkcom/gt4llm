Class {
	#name : #GtSmaCCRewriteTransformationSpecification,
	#superclass : #Object,
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #converting }
GtSmaCCRewriteTransformationSpecification >> asSmaCCTransformation [
	self subclassResponsibility
]

{ #category : #accessing }
GtSmaCCRewriteTransformationSpecification >> errorMessage [
	^ nil
]

{ #category : #'llm views' }
GtSmaCCRewriteTransformationSpecification >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]
