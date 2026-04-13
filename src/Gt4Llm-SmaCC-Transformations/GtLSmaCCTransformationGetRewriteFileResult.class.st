Class {
	#name : #GtLSmaCCTransformationGetRewriteFileResult,
	#superclass : #Object,
	#instVars : [
		'rewriteFile'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #'llm views' }
GtLSmaCCTransformationGetRewriteFileResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLSmaCCTransformationGetRewriteFileResult >> rewriteFile [
	^ rewriteFile
]

{ #category : #accessing }
GtLSmaCCTransformationGetRewriteFileResult >> rewriteFile: anObject [
	rewriteFile := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationGetRewriteFileResult >> rewriteFileDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #rewriteFile;
		classes: {GtLSmaCCRewriteFileSpecification};
		beRequired
]
