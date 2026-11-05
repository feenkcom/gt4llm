Class {
	#name : #GtLTransformationProblem,
	#superclass : #Object,
	#instVars : [
		'description'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLTransformationProblem class >> description: aString [
	^self new initializeDescription: aString
]

{ #category : #accessing }
GtLTransformationProblem >> description [
	^description
]

{ #category : #descriptions }
GtLTransformationProblem >> descriptionDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Description';
		accessor: #description;
		beRequired
]

{ #category : #accessing }
GtLTransformationProblem >> gtDisplayOn: aStream [
	aStream nextPutAll: self description
]

{ #category : #initialization }
GtLTransformationProblem >> initializeDescription: aString [
	description := aString
]

{ #category : #'llm views' }
GtLTransformationProblem >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView magritteObject: [self]
]
