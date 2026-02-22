Class {
	#name : #GtLMagritteToolForFilesWrite,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForFilesWrite >> description [
	^ 'Writes the contents of multiple files. Arguments must provide a files array of file descriptors with path and contents values.

Example JSON arguments:
{
  "files": [
    {"path": "/path/to/one.txt", "contents": "First"},
    {"path": "/path/to/another.txt", "contents": "Second"}
  ]
}

Example JSON response:
{
  "files": [
    {"path": "/path/to/one.txt", "contents": "First"},
    {"path": "/path/to/another.txt", "contents": "Second"}
  ]
}'
]

{ #category : #accessing }
GtLMagritteToolForFilesWrite >> filesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		accessor: #files;
		classes: {GtLFileContentsDomainObject};
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForFilesWrite >> name [
	^ 'writeFiles'
]

{ #category : #private }
GtLMagritteToolForFilesWrite >> privatePerformToolCall: aToolCall [
	| arguments fileDescriptors fileObjects |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	fileDescriptors := arguments
		at: 'files'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'files' ].
	fileObjects := OrderedCollection new.
	fileDescriptors do: [ :each |
		| fileReference parentDirectory result |
		fileReference := each path asFileReference.
		(fileReference exists and: [ fileReference isDirectory ])
			ifTrue: [ ^ GtLIncorrectArgumentValueDomainObject new
					argumentName: 'path';
					argumentValue: each path;
					expectedArgumentValueKind: AbstractFileReference ].
		parentDirectory := fileReference parent.
		(parentDirectory notNil and: [ parentDirectory exists not ])
			ifTrue: [ parentDirectory ensureCreateDirectory ].
		result := [ fileReference writeStreamDo: [ :stream | stream nextPutAll: each contents ].
			fileReference readStreamDo: [ :stream |
				GtLFileContentsDomainObject new
					path: fileReference pathString;
					contents: stream contents asString ] ]
			on: Error
			do: [ :e | GtLExceptionDomainObject new freeze: e ].
		((result respondsTo: #isErrorDomainObject) and: [ result isErrorDomainObject ])
			ifTrue: [ ^ result ].
		fileObjects add: result ].
	^ GtLFilesContents new files: fileObjects asArray
]
