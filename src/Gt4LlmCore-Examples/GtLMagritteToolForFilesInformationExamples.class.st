"
Examples for the files information magritte tool.
"
Class {
	#name : #GtLMagritteToolForFilesInformationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForDirectory [
	<gtExample>
	| directory |
	directory := FileLocator temp / 'gt-llm-files-information'.
	[ | tool call targetObject |
		directory exists ifFalse: [ directory ensureCreateDirectory ].
		tool := GtLMagritteToolForFilesInformation new.
		call := self
			executeTool: tool
			withArguments: {
				'filePaths' -> { {'pathString' -> directory pathString} asDictionary } asArray
			} asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 1.
		self assert: targetObject files first path equals: directory pathString.
		self assert: targetObject files first type equals: 'directory'.
		^ call ]
		ensure: [ directory exists ifTrue: [ directory delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForDirectoryAndFile [
	<gtExample>
	| directory fileReference |
	directory := FileLocator temp / 'gt-llm-files-information-mixed'.
	fileReference := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	[ | tool call targetObject |
		directory exists ifFalse: [ directory ensureCreateDirectory ].
		fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Mixed' ].
		tool := GtLMagritteToolForFilesInformation new.
		call := self
			executeTool: tool
			withArguments: {
				'filePaths' -> {
					{ 'pathString' -> directory pathString } asDictionary.
					{ 'pathString' -> fileReference pathString } asDictionary
				} asArray
			} asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 2.
		self assert: targetObject files first path equals: directory pathString.
		self assert: targetObject files first type equals: 'directory'.
		self assert: targetObject files second path equals: fileReference pathString.
		self assert: targetObject files second type equals: 'file'.
		^ call ]
		ensure: [
			directory exists ifTrue: [ directory delete ].
			fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForExistingFiles [
	<gtExample>
	| fileOne fileTwo |
	fileOne := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	fileTwo := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	[ | tool call targetObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		tool := GtLMagritteToolForFilesInformation new.
		call := self
			executeTool: tool
			withArguments: {
				'filePaths' -> { 
					{'pathString' -> fileOne pathString} asDictionary.
					{'pathString' -> fileTwo pathString} asDictionary } asArray } asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 2.
		self assert: targetObject files first path equals: fileOne pathString.
		self assert: targetObject files second path equals: fileTwo pathString.
		^ call ]
		ensure: [
			fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForMissingFile [
	<gtExample>
	| missingPath existingFile |
	missingPath := (FileLocator temp / 'gt-llm-missing-file-info.txt') pathString.
	existingFile := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	[ | tool call targetObject |
		existingFile writeStreamDo: [ :stream | stream nextPutAll: 'Existing file' ].
		tool := GtLMagritteToolForFilesInformation new.
		call := self
			executeTool: tool
			withArguments: { 'filePaths' -> { {'pathString' -> missingPath} asDictionary.
				{'pathString' -> existingFile pathString} asDictionary } asArray } asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject files size equals: 2.
		self assert: targetObject files first isErrorDomainObject.
		self assert: targetObject files first objectName equals: missingPath.
		self assert: targetObject files second path equals: existingFile pathString.
		^ call ]
		ensure: [ existingFile exists ifTrue: [ existingFile delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationWithEmptyPath [
	<gtExample>
	| tool call targetObject |
	tool := GtLMagritteToolForFilesInformation new.
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
GtLMagritteToolForFilesInformationExamples >> filesInformationWithNilPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFilesInformation new.
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
GtLMagritteToolForFilesInformationExamples >> filesInformationWithoutPaths [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForFilesInformation new.
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
