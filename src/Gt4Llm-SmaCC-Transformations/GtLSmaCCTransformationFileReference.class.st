Class {
	#name : #GtLSmaCCTransformationFileReference,
	#superclass : #Object,
	#instVars : [
		'filename',
		'model'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationFileReference >> errorMessage [
	^ nil
]

{ #category : #accessing }
GtLSmaCCTransformationFileReference >> filename [
	^ filename
]

{ #category : #accessing }
GtLSmaCCTransformationFileReference >> filename: aString [
	filename := aString
]

{ #category : #accessing }
GtLSmaCCTransformationFileReference >> filenameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #filename;
		comment: 'Filename for the rules'
]

{ #category : #'llm views' }
GtLSmaCCTransformationFileReference >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLSmaCCTransformationFileReference >> model [
	^ model
]

{ #category : #accessing }
GtLSmaCCTransformationFileReference >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationFileReference >> rewriteFile [
	^ model specificationFor: filename
]
