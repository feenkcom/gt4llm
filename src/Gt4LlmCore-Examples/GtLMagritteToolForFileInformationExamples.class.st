"
Examples for the file information magritte tool.
"
Class {
	#name : #GtLMagritteToolForFileInformationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationForExistingFile [
	<gtExample>
	| fileReference |
	fileReference := FileReference newTempFilePrefix: 'GtLMagritteToolForFileInformation' suffix: '.txt'.
	[ | tool call targetObject |
		fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Metadata' ].
		tool := GtLMagritteToolForFileInformation new.
		call := self
			executeTool: tool
			withArguments: {
				'filePath' -> { 'pathString' -> fileReference pathString } asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLFileInformation).
		self assert: targetObject path equals: fileReference pathString.
		self assert: targetObject size equals: fileReference size.
		self assert: targetObject type equals: 'file'.
		self assert: targetObject permissions equals: fileReference permissions printString.
		^ call ]
		ensure: [ fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationForMissingFile [
	<gtExample>
	| missingPath tool call |
	missingPath := (FileLocator temp / 'gt-llm-missing-file-info.txt') pathString.
	tool := GtLMagritteToolForFileInformation new.
	call := self
		executeTool: tool
		withArguments: {
			'filePath' -> { 'pathString' -> missingPath } asDictionary
		} asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: missingPath 
		errorMessage: missingPath, ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithEmptyPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFileInformation new.
	call := self
		executeTool: tool
		withArguments: {
			'filePath' -> { 'pathString' -> '' } asDictionary
		} asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: '' 
		errorMessage: ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithNilPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFileInformation new.
	call := self
		executeTool: tool
		withArguments: { 'filePath' -> nil } asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('filePath') 
		errorMessage: '@[filePath] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithoutPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFileInformation new.
	call := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('filePath') 
		path: #(nil) 
		errorMessage: 'required properties missing [filePath]'.
	^ call
]
