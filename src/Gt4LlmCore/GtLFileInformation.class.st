"
Contains metadata for a file or directory returned by LLM tools.
"
Class {
	#name : #GtLFileInformation,
	#superclass : #Object,
	#instVars : [
		'path',
		'size',
		'creationTime',
		'modificationTime',
		'accessTime',
		'type',
		'permissions'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLFileInformation >> accessTime [
	^ accessTime
]

{ #category : #accessing }
GtLFileInformation >> accessTime: aDateAndTime [
	accessTime := aDateAndTime
]

{ #category : #magritte }
GtLFileInformation >> accessTimeDescription [
	<magritteDescription>

	^ MADateAndTimeDescription new
		label: 'Access time';
		accessor: #accessTime;
		beRequired
]

{ #category : #accessing }
GtLFileInformation >> creationTime [
	^ creationTime
]

{ #category : #accessing }
GtLFileInformation >> creationTime: aDateAndTime [
	creationTime := aDateAndTime
]

{ #category : #magritte }
GtLFileInformation >> creationTimeDescription [
	<magritteDescription>

	^ MADateAndTimeDescription new
		label: 'Creation time';
		accessor: #creationTime;
		beRequired
]

{ #category : #'gt-view' }
GtLFileInformation >> gtDetailsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Details';
		priority: 1;
		items: [ {
			{'Path'. self path}.
			{'Type'. self type}.
			{'Size'. self size}.
			{'Creation time'. self creationTime}.
			{'Modified time'. self modificationTime}.
			{'Access time'. self accessTime}.
			{'Permissions'. self permissions}
		} ];
		column: 'Field' text: [ :each | each first ];
		column: 'Value' text: [ :each | each second printString ]
]

{ #category : #printing }
GtLFileInformation >> gtDisplayOn: aStream [
	aStream nextPutAll: self path
]

{ #category : #initialization }
GtLFileInformation >> initializeFromFileReference: aFileReference [
	path := aFileReference pathString.
	size := aFileReference size.
	creationTime := aFileReference creationTime.
	modificationTime := aFileReference modificationTime.
	accessTime := aFileReference accessTime.
	type := aFileReference isDirectory
		ifTrue: [ 'directory' ]
		ifFalse: [ 'file' ].
	permissions := aFileReference permissions printString
]

{ #category : #accessing }
GtLFileInformation >> modificationTime [
	^ modificationTime
]

{ #category : #accessing }
GtLFileInformation >> modificationTime: aDateAndTime [
	modificationTime := aDateAndTime
]

{ #category : #magritte }
GtLFileInformation >> modificationTimeDescription [
	<magritteDescription>

	^ MADateAndTimeDescription new
		label: 'Modified time';
		accessor: #modificationTime;
		beRequired
]

{ #category : #accessing }
GtLFileInformation >> path [
	^ path
]

{ #category : #accessing }
GtLFileInformation >> path: aString [
	path := aString
]

{ #category : #magritte }
GtLFileInformation >> pathDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Path';
		accessor: #path;
		beRequired
]

{ #category : #accessing }
GtLFileInformation >> permissions [
	^ permissions
]

{ #category : #accessing }
GtLFileInformation >> permissions: aString [
	permissions := aString
]

{ #category : #magritte }
GtLFileInformation >> permissionsDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Permissions';
		accessor: #permissions;
		beRequired
]

{ #category : #accessing }
GtLFileInformation >> size [
	^ size
]

{ #category : #accessing }
GtLFileInformation >> size: aNumber [
	size := aNumber
]

{ #category : #magritte }
GtLFileInformation >> sizeDescription [
	<magritteDescription>

	^ MANumberDescription new
		label: 'Size';
		accessor: #size;
		beRequired
]

{ #category : #accessing }
GtLFileInformation >> type [
	^ type
]

{ #category : #accessing }
GtLFileInformation >> type: aString [
	type := aString
]

{ #category : #magritte }
GtLFileInformation >> typeDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Type';
		accessor: #type;
		beRequired
]
