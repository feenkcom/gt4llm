Class {
	#name : #GtLSmaCCSuccess,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : #'Gt4Llm-SmaCC-Domain Objects'
}

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
