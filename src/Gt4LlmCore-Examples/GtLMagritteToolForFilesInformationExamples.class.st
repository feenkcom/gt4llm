"
Examples for the files information magritte tool.
"
Class {
	#name : #GtLMagritteToolForFilesInformationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForDirectory [
	<gtExample>
	| directory tool call result model |
	directory := FileLocator temp / 'gt-llm-files-information'.
	[ directory exists ifFalse: [ directory ensureCreateDirectory ].
		tool := GtLMagritteToolForFilesInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'filePaths' -> { {'pathString' -> directory pathString} asDictionary } asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: model files size equals: 1.
		self assert: model files first path equals: directory pathString.
		self assert: model files first type equals: 'directory'.
		^ call ]
		ensure: [ directory exists ifTrue: [ directory delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForDirectoryAndFile [
	<gtExample>
	| directory fileReference tool call result model |
	directory := FileLocator temp / 'gt-llm-files-information-mixed'.
	fileReference := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	[ directory exists ifFalse: [ directory ensureCreateDirectory ].
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
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: model files size equals: 2.
		self assert: model files first path equals: directory pathString.
		self assert: model files first type equals: 'directory'.
		self assert: model files second path equals: fileReference pathString.
		self assert: model files second type equals: 'file'.
		^ call ]
		ensure: [
			directory exists ifTrue: [ directory delete ].
			fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationForExistingFiles [
	<gtExample>
	| fileOne fileTwo tool call result model |
	fileOne := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	fileTwo := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesInformation' suffix: '.txt'.
	[ fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		tool := GtLMagritteToolForFilesInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'filePaths' -> { 
				{'pathString' -> fileOne pathString} asDictionary.
				{'pathString' -> fileTwo pathString} asDictionary } asArray } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		self assert: call arguments size equals: 1.
		self assert: (call arguments anyOne allSatisfy: [ :each | each isKindOf: GtLFilePathReference ]).
		model := result model.
		self assert: model files size equals: 2.
		self assert: model files first path equals: fileOne pathString.
		self assert: model files second path equals: fileTwo pathString.
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
	[ |tool call result model|
		existingFile writeStreamDo: [ :stream | stream nextPutAll: 'Existing file' ].
		tool := GtLMagritteToolForFilesInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'filePaths' -> { {'pathString' -> missingPath} asDictionary.
			{'pathString' -> existingFile pathString} asDictionary } asArray } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: call arguments size equals: 1.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: model files size equals: 2.
		self assert: model files first isErrorDomainObject.
		self assert: model files first objectName equals: missingPath.
		self assert: model files second path equals: existingFile pathString.
		^ call ]
		ensure: [ existingFile exists ifTrue: [ existingFile delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationWithEmptyPath [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForFilesInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'filePaths' -> { { 'pathString' -> '' } asDictionary } asArray } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model files size equals: 1.
	self assert: model files first isErrorDomainObject.
	self assert: (model files first isKindOf: GtLMissingDomainObject).
	self assert: model files first objectName equals: ''.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationWithNilPath [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForFilesInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'filePaths' -> { nil } asArray } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: model path asArray equals: #('filePaths' 1).
	self assert: model errorMessage equals: '@[filePaths/1] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesInformationExamples >> filesInformationWithoutPaths [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForFilesInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('filePaths').
	^ call
]
