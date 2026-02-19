Class {
	#name : #GtLFilesContents,
	#superclass : #Object,
	#instVars : [
		'files'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLFilesContents >> files [
	^ files
]

{ #category : #accessing }
GtLFilesContents >> files: aCollection [
	files := aCollection
]

{ #category : #accessing }
GtLFilesContents >> filesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		accessor: #files;
		classes: {GtLFileContentsDomainObject};
		beRequired
]

{ #category : #views }
GtLFilesContents >> gtFilesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ self files ];
		column: 'File' text: [ :each | each path ];
		column: 'Content' text: [ :each | (each contents first: (100 min: each contents size)) ]
]
