"
Returns metadata about multiple files or directories for provided file paths.
"
Class {
	#name : #GtLMagritteToolForFilesInformation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForFilesInformation >> description [
	^ 'Gets information about multiple files or directories. Arguments must provide a filePaths array of GtLFilePathReference objects.

Return values:
- files: array of file information objects with fields:
  - path: string with the absolute path
  - size: integer number of bytes
  - creationTime: ISO-8601 timestamp (RFC3339)
  - modificationTime: ISO-8601 timestamp (RFC3339)
  - accessTime: ISO-8601 timestamp (RFC3339)
  - type: "file" or "directory"
  - permissions: string representation like "rw-r--r--"

Example JSON arguments:
{
  "filePaths": [
    {"pathString": "/path/to/file.txt"},
    {"pathString": "/path/to/directory"}
  ]
}

Example JSON response:
{
  "files": [
    {
      "path": "/path/to/file.txt",
      "size": 42,
      "creationTime": "2024-04-29T12:34:56Z",
      "modificationTime": "2024-04-29T12:34:56Z",
      "accessTime": "2024-04-29T12:34:56Z",
      "type": "file",
      "permissions": "rw-r--r--"
    },
    {
      "path": "/path/to/directory",
      "size": 4096,
      "creationTime": "2024-04-29T12:34:56Z",
      "modificationTime": "2024-04-29T12:34:56Z",
      "accessTime": "2024-04-29T12:34:56Z",
      "type": "directory",
      "permissions": "rwxr-xr-x"
    }
  ]
}'
]

{ #category : #magritte }
GtLMagritteToolForFilesInformation >> filePathsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		accessor: #filePaths;
		classes: {GtLFilePathReference};
		beRequired
]

{ #category : #private }
GtLMagritteToolForFilesInformation >> informationForFilePath: aFilePathReference [
	| fileReference |
	aFilePathReference pathString isEmpty
		ifTrue: [ ^ GtLMissingDomainObject new objectName: aFilePathReference pathString ].
	fileReference := aFilePathReference pathString asFileReference.
	fileReference exists
		ifFalse: [ ^ GtLMissingDomainObject new objectName: fileReference pathString ].
	^ [ GtLFileInformation new
			initializeFromFileReference: fileReference;
			yourself ]
		on: Error
		do: [ :error | GtLExceptionDomainObject freeze: error ]
]

{ #category : #testing }
GtLMagritteToolForFilesInformation >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLMagritteToolForFilesInformation >> name [
	^ 'getFilesInformation'
]

{ #category : #private }
GtLMagritteToolForFilesInformation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments filePaths fileObjects |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	filePaths := arguments at: 'filePaths'.
	fileObjects := filePaths collect: [ :pathReference |
		self informationForFilePath: pathReference ].
	^ GtLFilesInformation new
		files: fileObjects asArray;
		yourself
]
