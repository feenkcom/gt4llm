"
Examples for the file information magritte tool.
"
Class {
	#name : #GtLMagritteToolForFileInformationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationForExistingFile [
	<gtExample>
	| fileReference tool call result model |
	fileReference := FileReference newTempFilePrefix: 'GtLMagritteToolForFileInformation' suffix: '.txt'.
	[ fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Metadata' ].
		tool := GtLMagritteToolForFileInformation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'filePath' -> { 'pathString' -> fileReference pathString } asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: call arguments size equals: 1.
		self assert: ((call arguments at: 'filePath') isKindOf: GtLFilePathReference).
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLFileInformation).
		self assert: model path equals: fileReference pathString.
		self assert: model size equals: fileReference size.
		self assert: model type equals: 'file'.
		self assert: model permissions equals: fileReference permissions printString.
		^ call ]
		ensure: [ fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationForMissingFile [
	<gtExample>
	| missingPath tool call result model |
	missingPath := (FileLocator temp / 'gt-llm-missing-file-info.txt') pathString.
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'filePath' -> { 'pathString' -> missingPath } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: missingPath.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithEmptyPath [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'filePath' -> { 'pathString' -> '' } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: ''.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithNilPath [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'filePath' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: model path asArray equals: #('filePath').
	self assert: model errorMessage equals: '@[filePath] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFileInformationExamples >> fileInformationWithoutPath [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForFileInformation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames asArray equals: #('filePath').
	^ call
]
