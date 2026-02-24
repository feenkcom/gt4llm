Class {
	#name : #GtLFileContentsDomainObject,
	#superclass : #Object,
	#instVars : [
		'path',
		'contents'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'as yet unclassified' }
GtLFileContentsDomainObject >> contents [
	^ contents
]

{ #category : #accessing }
GtLFileContentsDomainObject >> contents: aString [ 
	contents := aString
]

{ #category : #'as yet unclassified' }
GtLFileContentsDomainObject >> contentsDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Contents';
		accessor: #contents;
		comment: 'The content of a file encoded as base64';
		beRequired
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
GtLFileContentsDomainObject >> path [
	^ path
]

{ #category : #accessing }
GtLFileContentsDomainObject >> path: aString [
	path := aString
]

{ #category : #'as yet unclassified' }
GtLFileContentsDomainObject >> pathDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Path';
		accessor: #path;
		beRequired
]
