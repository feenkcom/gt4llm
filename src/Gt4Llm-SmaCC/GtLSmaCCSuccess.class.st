Class {
	#name : #GtLSmaCCSuccess,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : #'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #testing }
GtLSmaCCSuccess >> isErrorDomainObject [
	^ false
]

{ #category : #'llm views' }
GtLSmaCCSuccess >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLSmaCCSuccess >> message [
	^ message
]

{ #category : #accessing }
GtLSmaCCSuccess >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtLSmaCCSuccess >> messageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Message';
		accessor: #message;
		beRequired
]
