Class {
	#name : #GtLSmaCCTransformationRunnerException,
	#superclass : #Object,
	#instVars : [
		'rewriteId',
		'line',
		'column',
		'message'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> column [
	^ column
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> column: anObject [
	column := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> columnDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #column;
		comment: 'The column of the node that was matched where the error occurred.'
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> line [
	^ line
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> line: anObject [
	line := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> lineDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #line;
		comment: 'The line of the node that was matched where the error occurred.'
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationRunnerException >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> message [
	^ message
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> messageDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #message;
		comment: 'The error message.'
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> rewriteId [
	^ rewriteId
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> rewriteId: anObject [
	rewriteId := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRunnerException >> rewriteIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #rewriteId;
		comment: 'The id of the rewrite that caused the error.'
]
