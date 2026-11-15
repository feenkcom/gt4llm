"
A changed Iceberg definition. Path is a logical diff-tree path, not necessarily a filesystem path. Old contents are the reference version; new contents are the working-copy version.
"
Class {
	#name : #GtLGitChange,
	#superclass : #Object,
	#instVars : [
		'path',
		'kind',
		'oldContents',
		'newContents'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #initialization }
GtLGitChange >> initializeFromNode: aNode [
	| operation |
	operation := aNode value.
	path := aNode path pathString.
	kind := operation isAddition
			ifTrue: [ 'addition' ]
			ifFalse: [ operation isRemoval ifTrue: [ 'removal' ] ifFalse: [ 'modification' ] ].
	oldContents := operation rightContents asString.
	newContents := operation leftContents asString
]

{ #category : #accessing }
GtLGitChange >> kind [
	^ kind
]

{ #category : #magritte }
GtLGitChange >> kindDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #kind;
		beReadOnly
]

{ #category : #llm }
GtLGitChange >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLGitChange >> newContents [
	^ newContents
]

{ #category : #magritte }
GtLGitChange >> newContentsDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #newContents;
		beReadOnly
]

{ #category : #accessing }
GtLGitChange >> oldContents [
	^ oldContents
]

{ #category : #magritte }
GtLGitChange >> oldContentsDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #oldContents;
		beReadOnly
]

{ #category : #accessing }
GtLGitChange >> path [
	^ path
]

{ #category : #magritte }
GtLGitChange >> pathDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #path;
		beReadOnly
]
