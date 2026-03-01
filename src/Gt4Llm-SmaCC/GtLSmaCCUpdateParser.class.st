Class {
	#name : #GtLSmaCCUpdateParser,
	#superclass : #Object,
	#instVars : [
		'edits',
		'parserClass'
	],
	#category : #'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCUpdateParser >> edits [
	^ edits
]

{ #category : #accessing }
GtLSmaCCUpdateParser >> edits: anObject [
	edits := anObject
]

{ #category : #accessing }
GtLSmaCCUpdateParser >> editsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Edit operations';
		accessor: #edits;
		classes: {GtLSmaCCEditOperation};
		beRequired
]

{ #category : #accessing }
GtLSmaCCUpdateParser >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCUpdateParser >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCUpdateParser >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Class';
		accessor: #parserClass;
		beRequired
]
