"
Examples for the file information magritte tool.
"
Class {
	#name : #GtLMagritteToolForFileInformationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationForExistingFile [
	<gtExample>
	| fileReference |
	fileReference := FileReference newTempFilePrefix: 'GtLMagritteToolForFileInformation' suffix: '.txt'.
	[ | tool call result domainObject |
		fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Metadata' ].
		tool := GtLMagritteToolForFileInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'filePath' -> { 'pathString' -> fileReference pathString } asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: call arguments size equals: 1.
		self assert: ((call arguments at: 'filePath') isKindOf: GtLFilePathReference).
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLFileInformation).
		self assert: domainObject path equals: fileReference pathString.
		self assert: domainObject size equals: fileReference size.
		self assert: domainObject type equals: 'file'.
		self assert: domainObject permissions equals: fileReference permissions printString.
		^ domainObject ]
		ensure: [ fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationForMissingFile [
	<gtExample>
	| missingPath tool call result domainObject |
	missingPath := (FileLocator temp / 'gt-llm-missing-file-info.txt') pathString.
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'filePath' -> { 'pathString' -> missingPath } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: missingPath 
		errorMessage: missingPath, ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithEmptyPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'filePath' -> { 'pathString' -> '' } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: '' 
		errorMessage: ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithNilPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'filePath' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('filePath') 
		errorMessage: '@[filePath] object expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithoutPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('filePath') 
		path: #(nil) 
		errorMessage: 'required properties missing [filePath]'.
	^ domainObject
]
