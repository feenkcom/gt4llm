Class {
	#name : #GtLDirectoryContents,
	#superclass : #Object,
	#instVars : [
		'directoryPath',
		'files',
		'directories'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLDirectoryContents >> directories [
	^ directories
]

{ #category : #accessing }
GtLDirectoryContents >> directories: aCollection [
	directories := aCollection
]

{ #category : #magritte }
GtLDirectoryContents >> directoriesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Directories';
		accessor: #directories;
		classes: {GtLFilePathReference};
		beRequired
]

{ #category : #accessing }
GtLDirectoryContents >> directoryPath [
	^ directoryPath
]

{ #category : #accessing }
GtLDirectoryContents >> directoryPath: aString [
	directoryPath := aString
]

{ #category : #magritte }
GtLDirectoryContents >> directoryPathDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Directory';
		accessor: #directoryPath;
		beRequired
]

{ #category : #accessing }
GtLDirectoryContents >> files [
	^ files
]

{ #category : #accessing }
GtLDirectoryContents >> files: aCollection [
	files := aCollection
]

{ #category : #magritte }
GtLDirectoryContents >> filesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Files';
		accessor: #files;
		classes: {GtLFilePathReference};
		beRequired
]

{ #category : #'gt-views' }
GtLDirectoryContents >> gtDirectoriesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Directories';
		priority: 1;
		items: [ self directories ];
		column: 'Path' text: [ :each | each pathString ]
]

{ #category : #printing }
GtLDirectoryContents >> gtDisplayOn: aStream [
	aStream nextPutAll: self directoryPath
]

{ #category : #'gt-views' }
GtLDirectoryContents >> gtFilesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Files';
		priority: 2;
		items: [ self files ];
		column: 'Path' text: [ :each | each pathString ]
]
