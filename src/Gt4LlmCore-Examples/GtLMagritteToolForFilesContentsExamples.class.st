Class {
	#name : #GtLMagritteToolForFilesContentsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsForExistingFiles [
	<gtExample>
	| fileOne fileTwo |
	fileOne := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesContents' suffix: 'one.txt'.
	fileTwo := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesContents' suffix: 'two.txt'.
	[ | tool call result domainObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		tool := GtLMagritteToolForFilesContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
		 'filePaths' -> { 
				{'pathString' -> fileOne pathString} asDictionary.
				{'pathString' -> fileTwo pathString} asDictionary } asArray } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		self assert: call arguments size equals: 1.
		self assert: (call arguments anyOne allSatisfy: [ :each | each isKindOf: GtLFilePathReference ]).
		domainObject := result targetObject.
		self assert: domainObject files size equals: 2.
		self assert: domainObject files first path equals: fileOne pathString.
		self assert: domainObject files first contents equals: 'First file' asByteArray base64Encoded.
		self assert: domainObject files second path equals: fileTwo pathString.
		self assert: domainObject files second contents equals: 'Second file' asByteArray base64Encoded.
		^ domainObject ]
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
	[ | tool call result domainObject |
		existingFile writeStreamDo: [ :stream | stream nextPutAll: 'Existing file' ].
		tool := GtLMagritteToolForFilesContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'filePaths' -> { {'pathString' -> missingPath} asDictionary.
			{'pathString' -> existingFile pathString} asDictionary } asArray } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: domainObject files size equals: 2.
		self assert: domainObject files first isErrorDomainObject.
		self assert: domainObject files first objectName equals: missingPath.
		self assert: domainObject files second contents equals: 'Existing file' asByteArray base64Encoded.
		^ domainObject ]
		ensure: [ existingFile exists ifTrue: [ existingFile delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsWithEmptyPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'filePaths' -> { { 'pathString' -> '' } asDictionary } asArray } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject files size equals: 1.
	self assert: domainObject files first isErrorDomainObject.
	self assert: (domainObject files first isKindOf: GtLMissingDomainObject).
	self assert: domainObject files first objectName equals: ''.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsWithNilPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'filePaths' -> { nil } asArray } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('filePaths' 1) 
		errorMessage: '@[filePaths/1] object expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsWithoutPaths [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('filePaths') 
		path: #(nil) 
		errorMessage: 'required properties missing [filePaths]'.
	^ domainObject
]
