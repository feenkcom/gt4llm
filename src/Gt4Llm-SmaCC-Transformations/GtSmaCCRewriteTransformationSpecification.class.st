Class {
	#name : #GtSmaCCRewriteTransformationSpecification,
	#superclass : #Object,
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #converting }
GtSmaCCRewriteTransformationSpecification >> asSmaCCTransformation [
	self subclassResponsibility
]

{ #category : #testing }
GtSmaCCRewriteTransformationSpecification >> isValid [
	^ true
]

{ #category : #'llm views' }
GtSmaCCRewriteTransformationSpecification >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]
