Class {
	#name : #GtLMagritteToolForDirectoryContents,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForDirectoryContents >> description [
	^ 'Gets the files and directories inside a directory. Arguments must provide a directory path string.

Example JSON arguments:
{
  "directoryPath": "/path/to/directory"
}

Example JSON response:
{
  "directoryPath": "/path/to/directory",
  "files": [
    {"pathString": "/path/to/directory/file-one.txt"},
    {"pathString": "/path/to/directory/file-two.txt"}
  ],
  "directories": [
    {"pathString": "/path/to/directory/sub-directory"}
  ]
}'
]

{ #category : #processing }
GtLMagritteToolForDirectoryContents >> directoryContentsFor: aPathString [
	| reference files directories |
	reference := aPathString asFileReference.
	reference isDirectory
		ifFalse: [ ^ GtLIncorrectArgumentValueDomainObject new
			argumentName: 'directoryPath';
			argumentValue: aPathString;
			expectedArgumentValueKind: AbstractFileReference ].
	files := reference files
		collect: [ :each | GtLFilePathReference new pathString: each pathString ].
	directories := reference directories
		collect: [ :each | GtLFilePathReference new pathString: each pathString ].
	^ GtLDirectoryContents new
		directoryPath: aPathString;
		files: files asArray;
		directories: directories asArray
]

{ #category : #magritte }
GtLMagritteToolForDirectoryContents >> directoryPathDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Directory';
		accessor: #directoryPath;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForDirectoryContents >> name [
	^ 'getDirectoryContents'
]

{ #category : #processing }
GtLMagritteToolForDirectoryContents >> privatePerformToolCall: aToolCall [
	| arguments path directoryReference |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	path := arguments
		at: 'directoryPath'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'directoryPath' ].
	(directoryReference := path asFileReference) exists
		ifFalse: [ ^ GtLMissingDomainObject new objectName: path ].
	^ self directoryContentsFor: directoryReference pathString
]
