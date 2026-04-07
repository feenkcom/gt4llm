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
	[ | tool call result domainObject |
		directory exists ifFalse: [ directory ensureCreateDirectory ].
		tool := GtLMagritteToolForFilesInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'filePaths' -> { {'pathString' -> directory pathString} asDictionary } asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: domainObject files size equals: 1.
		self assert: domainObject files first path equals: directory pathString.
		self assert: domainObject files first type equals: 'directory'.
		^ domainObject ]
		ensure: [ directory exists ifTrue: [ directory delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForDirectoryAndFile [
	<gtExample>
	| directory fileReference |
	directory := FileLocator temp / 'gt-llm-files-information-mixed'.
	fileReference := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	[ | tool call result domainObject |
		directory exists ifFalse: [ directory ensureCreateDirectory ].
		fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Mixed' ].
		tool := GtLMagritteToolForFilesInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'filePaths' -> {
				{ 'pathString' -> directory pathString } asDictionary.
				{ 'pathString' -> fileReference pathString } asDictionary
			} asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: domainObject files size equals: 2.
		self assert: domainObject files first path equals: directory pathString.
		self assert: domainObject files first type equals: 'directory'.
		self assert: domainObject files second path equals: fileReference pathString.
		self assert: domainObject files second type equals: 'file'.
		^ domainObject ]
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
	[ | tool call result domainObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		tool := GtLMagritteToolForFilesInformation new.
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
		self assert: domainObject files second path equals: fileTwo pathString.
		^ domainObject ]
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
	[ | tool call result domainObject |
		existingFile writeStreamDo: [ :stream | stream nextPutAll: 'Existing file' ].
		tool := GtLMagritteToolForFilesInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'filePaths' -> { {'pathString' -> missingPath} asDictionary.
			{'pathString' -> existingFile pathString} asDictionary } asArray } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: call arguments size equals: 1.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: domainObject files size equals: 2.
		self assert: domainObject files first isErrorDomainObject.
		self assert: domainObject files first objectName equals: missingPath.
		self assert: domainObject files second path equals: existingFile pathString.
		^ domainObject ]
		ensure: [ existingFile exists ifTrue: [ existingFile delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationWithEmptyPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesInformation new.
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
GtLMagritteToolForFilesInformationExamples >> filesInformationWithNilPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesInformation new.
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
GtLMagritteToolForFilesInformationExamples >> filesInformationWithoutPaths [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('filePaths') 
		path: #(nil) 
		errorMessage: 'required properties missing [filePaths]'.
	^ domainObject
]
