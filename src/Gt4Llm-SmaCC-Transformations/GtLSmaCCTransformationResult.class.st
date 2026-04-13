Class {
	#name : #GtLSmaCCTransformationResult,
	#superclass : #Object,
	#instVars : [
		'transformedSource'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #'llm views' }
GtLSmaCCTransformationResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLSmaCCTransformationResult >> transformedSource [
	^ transformedSource
]

{ #category : #accessing }
GtLSmaCCTransformationResult >> transformedSource: anObject [
	transformedSource := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationResult >> transformedSourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #transformedSource;
		comment: 'The source after the rewrite rules have been applied.'
]
