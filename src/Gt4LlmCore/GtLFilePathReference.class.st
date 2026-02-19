Class {
	#name : #GtLFilePathReference,
	#superclass : #Object,
	#instVars : [
		'pathString'
	],
	#category : #'Gt4LlmCore-Domain Objects'
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
GtLFilePathReference >> gtFileContentsFor: aView [
	<gtView>
	^ (self asFileReference exists and: [ self asFileReference isFile ]) ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'gtContentsFor:';
		object: [ self asFileReference ];
		view: #gtContentsFor:
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
