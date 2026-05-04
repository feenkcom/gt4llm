Class {
	#name : #GtLSmaCCRewriteFileSpecification,
	#superclass : #GtLSmaCCRewriteFileReferenceSpecification,
	#instVars : [
		'rules',
		'parserClass'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification class >> jsonSchemaLabel [
	^ 'SmaCCRewriteFile'
]

{ #category : #converting }
GtLSmaCCRewriteFileSpecification >> asSmaCCRewriteIn: aModel [
	| file |
	file := SmaCCRewriteFile new.
	file filename: self filename.
	file
		parserClass: (Smalltalk at: self parserClass asSymbol ifAbsent: [ SmaCCParser ]).
	file
		rewrites: (self rules
				collect: [ :each | 
					(each asSmaCCRewriteIn: aModel)
						parent: file;
						yourself ]).
	^ file
]

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification >> errorMessage [
	self rules do: [ :each | each errorMessage ifNotNil: [ :msg | ^ msg ] ].
	^ nil
]

{ #category : #initialization }
GtLSmaCCRewriteFileSpecification >> initialize [
	super initialize.
	rules := OrderedCollection new
]

{ #category : #testing }
GtLSmaCCRewriteFileSpecification >> isRewriteFile [
	^ true
]

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #parserClass;
		comment: 'The parser class to use to parse the search patterns.'
]

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification >> rules [
	^ rules
]

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification >> rules: anObject [
	rules := anObject
]

{ #category : #accessing }
GtLSmaCCRewriteFileSpecification >> rulesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #rules;
		classes: GtLSmaCCAbstractRewriteSpecification subclasses;
		useExplicitContainerForChildren
]
