Class {
	#name : #GtLFileContentsDomainObject,
	#superclass : #Object,
	#instVars : [
		'path',
		'contents'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLFileContentsDomainObject >> contents [
	^ contents
]

{ #category : #accessing }
GtLFileContentsDomainObject >> contents: aString [
	contents := aString
]

{ #category : #accessing }
GtLFileContentsDomainObject >> contentsDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Contents';
		accessor: #contents;
		beRequired
]

{ #category : #views }
GtLFileContentsDomainObject >> gtContentsFor: aView [
	<gtView>
	contents ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Contents';
		priority: 1;
		text: [ contents ]
]

{ #category : #'as yet unclassified' }
GtLFileContentsDomainObject >> gtDisplayOn: stream [
	stream nextPutAll: self path
]

{ #category : #accessing }
GtLFileContentsDomainObject >> path [
	^ path
]

{ #category : #accessing }
GtLFileContentsDomainObject >> path: aPathString [
	path := aPathString
]

{ #category : #accessing }
GtLFileContentsDomainObject >> pathDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Path';
		accessor: #path;
		beRequired
]
