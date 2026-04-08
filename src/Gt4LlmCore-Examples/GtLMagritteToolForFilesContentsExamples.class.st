Class {
	#name : #GtLMagritteToolForFilesContentsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsForExistingFiles [
	<gtExample>
	| fileOne fileTwo |
	fileOne := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesContents' suffix: 'one.txt'.
	fileTwo := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesContents' suffix: 'two.txt'.
	[ | tool call targetObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		tool := GtLMagritteToolForFilesContents new.
		call := self
			executeTool: tool
			withArguments: {
				'filePaths' -> { 
					{'pathString' -> fileOne pathString} asDictionary.
					{'pathString' -> fileTwo pathString} asDictionary } asArray } asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 2.
		self assert: targetObject files first path equals: fileOne pathString.
		self assert: targetObject files first contents equals: 'First file' asByteArray base64Encoded.
		self assert: targetObject files second path equals: fileTwo pathString.
		self assert: targetObject files second contents equals: 'Second file' asByteArray base64Encoded.
		^ call ]
		ensure: [
			fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsForMissingFile [
	<gtExample>
	| missingPath existingFile |
	missingPath := (FileLocator temp / 'gt-llm-missing-file.txt') pathString.
	existingFile := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesContents' suffix: 'existing.txt'.
	[ | tool call targetObject |
		existingFile writeStreamDo: [ :stream | stream nextPutAll: 'Existing file' ].
		tool := GtLMagritteToolForFilesContents new.
		call := self
			executeTool: tool
			withArguments: { 'filePaths' -> { {'pathString' -> missingPath} asDictionary.
				{'pathString' -> existingFile pathString} asDictionary } asArray } asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 2.
		self assert: targetObject files first isErrorDomainObject.
		self assert: targetObject files first objectName equals: missingPath.
		self assert: targetObject files second contents equals: 'Existing file' asByteArray base64Encoded.
		^ call ]
		ensure: [ existingFile exists ifTrue: [ existingFile delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsWithEmptyPath [
	<gtExample>
	| tool call targetObject |
	tool := GtLMagritteToolForFilesContents new.
	call := self
		executeTool: tool
		withArguments: { 'filePaths' -> { { 'pathString' -> '' } asDictionary } asArray } asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject files size equals: 1.
	self assert: targetObject files first isErrorDomainObject.
	self assert: (targetObject files first isKindOf: GtLMissingDomainObject).
	self assert: targetObject files first objectName equals: ''.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsWithNilPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFilesContents new.
	call := self
		executeTool: tool
		withArguments: { 'filePaths' -> { nil } asArray } asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('filePaths' 1) 
		errorMessage: '@[filePaths/1] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsWithoutPaths [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFilesContents new.
	call := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('filePaths') 
		path: #(nil) 
		errorMessage: 'required properties missing [filePaths]'.
	^ call
]
