Class {
	#name : #GtLSmaCCTransformationCreateFile,
	#superclass : #GtLSmaCCTransformationFileReference,
	#instVars : [
		'parserClass'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #actions }
GtLSmaCCTransformationCreateFile >> createRewriteFile [
	| fileSpec |
	fileSpec := GtLSmaCCRewriteFileSpecification new.
	fileSpec filename: self filename.
	fileSpec parserClass: self parserClass.
	model addFile: fileSpec.
	^ fileSpec
]

{ #category : #accessing }
GtLSmaCCTransformationCreateFile >> errorMessage [
	| cls |
	cls := Smalltalk globals at: self parserClass asSymbol ifAbsent: [ nil ].
	^ (cls isKindOf: SmaCCParser class)
		ifFalse: [ '`' , self parserClass , '` is not a valid SmaCC parser class' ]
]

{ #category : #accessing }
GtLSmaCCTransformationCreateFile >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCTransformationCreateFile >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationCreateFile >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #parserClass;
		comment: 'The parser to use to parse the search patterns used in the file'
]
