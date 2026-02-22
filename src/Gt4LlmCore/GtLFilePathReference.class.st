Class {
	#name : #GtLFilePathReference,
	#superclass : #Object,
	#instVars : [
		'pathString'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #converting }
GtLFilePathReference >> asFileReference [
	^ self fileReference
]

{ #category : #accessing }
GtLFilePathReference >> contentsDomainObject [
	| fileReference |
	fileReference := self fileReference.
	^ [ fileReference
		readStreamDo: [ :stream | 
			GtLFileContentsDomainObject new
				path: fileReference pathString;
				contents: stream contents asString ]
		ifAbsent: [ GtLMissingDomainObject new objectName: fileReference pathString ] ]
		on: Error
		do: [ :e | GtLExceptionDomainObject new freeze: e ]
]

{ #category : #accessing }
GtLFilePathReference >> fileReference [
	^ self pathString asFileReference
]

{ #category : #views }
GtLFilePathReference >> gtDirectoryFor: aView [
	<gtView>
	^ (self asFileReference exists and: [ self asFileReference isDirectory ]) ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Directory';
		object: [ self asFileReference ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLFilePathReference >> gtFileContentsFor: aView [
	<gtView>
	^ (self asFileReference exists and: [ self asFileReference isFile ]) ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Contents';
		object: [ self asFileReference ];
		view: #gtContentsFor:
]

{ #category : #testing }
GtLFilePathReference >> isDirectory [
	^ self fileReference isDirectory
]

{ #category : #testing }
GtLFilePathReference >> isFile [
	^ self fileReference isFile
]

{ #category : #accessing }
GtLFilePathReference >> pathString [
	^ pathString
]

{ #category : #accessing }
GtLFilePathReference >> pathString: aString [
	pathString := aString
]

{ #category : #accessing }
GtLFilePathReference >> pathStringDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Path';
		accessor: #pathString;
		beRequired
]

{ #category : #printing }
GtLFilePathReference >> printOn: aStream [
	aStream nextPutAll: self pathString
]
