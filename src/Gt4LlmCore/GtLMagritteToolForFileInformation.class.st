"
Returns metadata about a file or directory for a provided file path.
"
Class {
	#name : #GtLMagritteToolForFileInformation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForFileInformation >> description [
	^ 'Gets information about a file or directory. Arguments must provide a filePath object of type GtLFilePathReference.

Return values:
- path: string with the absolute path
- size: integer number of bytes
- creationTime: ISO-8601 timestamp (RFC3339)
- modificationTime: ISO-8601 timestamp (RFC3339)
- accessTime: ISO-8601 timestamp (RFC3339)
- type: "file" or "directory"
- permissions: string representation like "rw-r--r--"

Example JSON arguments:
{
  "filePath": {"pathString": "/path/to/file.txt"}
}

Example JSON response for a file:
{
  "path": "/path/to/file.txt",
  "size": 42,
  "creationTime": "2024-04-29T12:34:56Z",
  "modificationTime": "2024-04-29T12:34:56Z",
  "accessTime": "2024-04-29T12:34:56Z",
  "type": "file",
  "permissions": "rw-r--r--"
}

Example JSON response for a directory:
{
  "path": "/path/to/directory",
  "size": 4096,
  "creationTime": "2024-04-29T12:34:56Z",
  "modificationTime": "2024-04-29T12:34:56Z",
  "accessTime": "2024-04-29T12:34:56Z",
  "type": "directory",
  "permissions": "rwxr-xr-x"
}'
]

{ #category : #magritte }
GtLMagritteToolForFileInformation >> filePathDescription [
	<magritteDescription>

	^ MAToOneRelationDescription new
		label: 'File path';
		accessor: #filePath;
		classes: {GtLFilePathReference};
		beRequired
]

{ #category : #private }
GtLMagritteToolForFileInformation >> informationForFilePath: aPathString [
	| fileReference |
	fileReference := aPathString asFileReference.
	fileReference exists
		ifFalse: [ ^ GtLMissingDomainObject new objectName: aPathString ].
	^ [ GtLFileInformation new
			initializeFromFileReference: fileReference;
			yourself ]
		on: Error
		do: [ :error | GtLExceptionDomainObject freeze: error ]
]

{ #category : #accessing }
GtLMagritteToolForFileInformation >> name [
	^ 'getFileInformation'
]

{ #category : #private }
GtLMagritteToolForFileInformation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments filePath |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	filePath := arguments at: 'filePath'.
	filePath pathString isEmpty
		ifTrue: [ ^ GtLMissingDomainObject new objectName: filePath pathString ].
	^ self informationForFilePath: filePath pathString
]
