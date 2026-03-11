"
Holds information about multiple files or directories.
"
Class {
	#name : #GtLFilesInformation,
	#superclass : #Object,
	#instVars : [
		'files'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLFilesInformation >> files [
	^ files
]

{ #category : #accessing }
GtLFilesInformation >> files: aCollection [
	files := aCollection
]

{ #category : #magritte }
GtLFilesInformation >> filesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Files';
		accessor: #files;
		classes: {GtLFileInformation};
		beRequired
]

{ #category : #'gt-view' }
GtLFilesInformation >> gtFilesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ self files ];
		column: 'Path' text: [ :each | each path ];
		column: 'Type' text: [ :each | each type ];
		column: 'Size' text: [ :each | each size printString ];
		column: 'Permissions' text: [ :each | each permissions ]
]
