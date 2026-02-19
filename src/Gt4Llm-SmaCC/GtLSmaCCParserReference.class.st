Class {
	#name : #GtLSmaCCParserReference,
	#superclass : #Object,
	#instVars : [
		'parserClass'
	],
	#category : #'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCParserReference >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCParserReference >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCParserReference >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Class';
		accessor: #parserClass;
		beRequired
]
