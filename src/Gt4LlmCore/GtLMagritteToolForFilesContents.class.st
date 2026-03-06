Class {
	#name : #GtLMagritteToolForFilesContents,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForFilesContents >> description [
	^ 'Gets the contents of multiple files. Arguments must provide a filePaths array of file path references. The contents is returned as a base64 encoded string.

Example JSON arguments:
{
  "filePaths": [
    {"pathString": "/path/to/one.txt"},
    {"pathString": "/path/to/another.txt"}
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
	(aPathString pathString isEmpty)
		ifTrue: [ ^ GtLMissingDomainObject new objectName: aPathString pathString ].
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
GtLMagritteToolForFilesContents >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
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
