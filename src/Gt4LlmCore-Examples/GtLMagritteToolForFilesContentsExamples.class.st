Class {
	#name : #GtLMagritteToolForFilesContentsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsForExistingFiles [
	<gtExample>
	| fileOne fileTwo |
	fileOne := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesContents' suffix: 'one.txt'.
	fileTwo := FileReference newTempFilePrefix: 'GtLMagritteToolForFilesContents' suffix: 'two.txt'.
	[ | tool call result model |
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
		self assert: (result isKindOf: GtLMagritteInputModel).
		self assert: call arguments size equals: 1.
		self assert: (call arguments anyOne allSatisfy: [ :each | each isKindOf: GtLFilePathReference ]).
		model := result model.
		self assert: model files size equals: 2.
		self assert: model files first path equals: fileOne pathString.
		self assert: model files first contents equals: 'First file' asByteArray base64Encoded.
		self assert: model files second path equals: fileTwo pathString.
		self assert: model files second contents equals: 'Second file' asByteArray base64Encoded .
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
	[ | tool call result model |
		existingFile writeStreamDo: [ :stream | stream nextPutAll: 'Existing file' ].
		tool := GtLMagritteToolForFilesContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'filePaths' -> { {'pathString' -> missingPath} asDictionary.
			{'pathString' -> existingFile pathString} asDictionary } asArray } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteInputModel).
		model := result model.
		self assert: model files size equals: 2.
		self assert: model files first isErrorDomainObject.
		self assert: model files first objectName equals: missingPath.
		self assert: model files second contents equals: 'Existing file' asByteArray base64Encoded.
		^ call ]
		ensure: [ existingFile exists ifTrue: [ existingFile delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesContentsExamples >> filesContentsWithoutPaths [
	<gtExample>
	| tool call result |
	tool := GtLMagritteToolForFilesContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model isErrorDomainObject.
	self assert: result model missingArgument equals: 'filePaths'.
	^ call
]
