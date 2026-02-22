Class {
	#name : #GtLMagritteToolForFilesContents,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForFilesContents >> description [
	^ 'Gets the contents of multiple files. Arguments must provide a filePaths array of path strings.

Example JSON arguments:
{
  "filePaths": [
    "/path/to/one.txt",
    "/path/to/another.txt"
  ]
}

Example JSON response:
{
  "files": [
    {"path": "/path/to/one.txt", "contents": "..."},
    {"path": "/path/to/another.txt", "contents": "..."}
  ]
}'
]

{ #category : #private }
GtLMagritteToolForFilesContents >> fileContentsFromPathString: aPathString [
	^ aPathString contentsDomainObject
]

{ #category : #accessing }
GtLMagritteToolForFilesContents >> filePathsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		accessor: #filePaths;
		classes: {GtLFilePathReference};
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForFilesContents >> name [
	^ 'getFilesContents'
]

{ #category : #private }
GtLMagritteToolForFilesContents >> privatePerformToolCall: aToolCall [
	| arguments filePaths fileObjects |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	filePaths := arguments
		at: 'filePaths'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'filePaths' ].
	fileObjects := filePaths collect: [ :pathReference |
		self fileContentsFromPathString: pathReference ].
	^ GtLFilesContents new files: fileObjects asArray
]
