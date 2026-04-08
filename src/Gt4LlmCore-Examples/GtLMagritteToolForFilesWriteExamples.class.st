Class {
	#name : #GtLMagritteToolForFilesWriteExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForDirectoryPath [
	<gtExample>
	| tempDirectory directoryPath |
	tempDirectory := GtTemporaryDirectory new.
	directoryPath := tempDirectory reference pathString.
	[ | tool call |
		tool := GtLMagritteToolForFilesWrite new.
		call := self
			executeTool: tool
			withArguments: {
				'files' -> { {'path' -> directoryPath. 'contents' -> 
					'Not a file' asByteArray base64Encoded} asDictionary } asArray
			} asDictionary.
		self 
			assertIncorrectArgumentType: call result targetObject 
			withArgumentName: 'path' 
			argumentValue: directoryPath 
			expectedKind: AbstractFileReference.
		^ call ]
		ensure: [ tempDirectory reference exists ifTrue: [ tempDirectory reference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForExistingFiles [
	<gtExample>
	| fileOne fileTwo |
	fileOne := FileReference
			newTempFilePrefix: 'GtLMagritteToolForFilesWrite'
			suffix: 'one.txt'.
	fileTwo := FileReference
			newTempFilePrefix: 'GtLMagritteToolForFilesWrite'
			suffix: 'two.txt'.
	[ | tool call targetObject |
		tool := GtLMagritteToolForFilesWrite new.
		call := self
			executeTool: tool
			withArguments: {'files'
					-> {{'path' -> fileOne pathString.
								'contents' -> 'First file' asByteArray base64Encoded} asDictionary.
							{'path' -> fileTwo pathString.
								'contents' -> 'Second file' asByteArray base64Encoded} asDictionary} asArray} asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 2.
		self assert: targetObject files first path equals: fileOne pathString.
		self assert: targetObject files first contents equals: 'First file' asByteArray base64Encoded.
		self assert: targetObject files second path equals: fileTwo pathString.
		self assert: targetObject files second contents equals: 'Second file' asByteArray base64Encoded.
		self assert: fileOne contents equals: 'First file'.
		self assert: fileTwo contents equals: 'Second file'.
		^ call ]
		ensure: [ fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForMissingParentDirectory [
	<gtExample>
	| tempDirectory nestedFile parentDirectory |
	tempDirectory := GtTemporaryDirectory new.
	parentDirectory := tempDirectory reference / 'nested'.
	nestedFile := parentDirectory / 'child.txt'.
	[ | tool call targetObject |
		tool := GtLMagritteToolForFilesWrite new.
		call := self
			executeTool: tool
			withArguments: {
				'files' -> { {'path' -> nestedFile pathString. 'contents' -> 'Nested file' asByteArray base64Encoded} asDictionary } asArray
			} asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 1.
		self assert: targetObject files first path equals: nestedFile pathString.
		self assert: targetObject files first contents equals: 'Nested file' asByteArray base64Encoded.
		self assert: parentDirectory exists.
		^ call ]
		ensure: [
			nestedFile exists ifTrue: [ nestedFile delete ].
			parentDirectory exists ifTrue: [ parentDirectory delete ].
			tempDirectory reference exists ifTrue: [ tempDirectory reference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteWithEmptyPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFilesWrite new.
	call := self
		executeTool: tool
		withArguments: { 'files' -> { {'path' -> ''. 'contents' -> 'Empty' asByteArray base64Encoded} asDictionary } asArray } asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: '' 
		errorMessage: ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteWithNilFiles [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFilesWrite new.
	call := self
		executeTool: tool
		withArguments: { 'files' -> { nil } asArray } asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('files' 1) 
		errorMessage: '@[files/1] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteWithoutFiles [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFilesWrite new.
	call := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('files') 
		path: #(nil) 
		errorMessage: 'required properties missing [files]'.
	^ call
]
