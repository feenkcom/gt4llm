Class {
	#name : #GtLMagritteToolForFilesWriteExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForDirectoryPath [
	<gtExample>
	| tool call result model tempDirectory directoryPath |
	tempDirectory := GtTemporaryDirectory new.
	directoryPath := tempDirectory reference pathString.
	[ tool := GtLMagritteToolForFilesWrite new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'files' -> { {'path' -> directoryPath. 'contents' -> 'Not a file'} asDictionary } asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteInputModel).
		model := result model.
		self assert: model isErrorDomainObject.
		self assert: model argumentName equals: 'path'.
		self assert: model argumentValue equals: directoryPath.
		self assert: model expectedArgumentValueKind equals: AbstractFileReference.
		^ call ]
		ensure: [ tempDirectory reference exists ifTrue: [ tempDirectory reference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForExistingFiles [
	<gtExample>
	| tool call result model fileOne fileTwo |
	fileOne := FileReference
			newTempFilePrefix: 'GtLMagritteToolForFilesWrite'
			suffix: 'one.txt'.
	fileTwo := FileReference
			newTempFilePrefix: 'GtLMagritteToolForFilesWrite'
			suffix: 'two.txt'.
	[ tool := GtLMagritteToolForFilesWrite new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'files'
					-> {{'path' -> fileOne pathString.
								'contents' -> 'First file'} asDictionary.
							{'path' -> fileTwo pathString.
								'contents' -> 'Second file'} asDictionary} asArray} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self
		assert: (call arguments anyOne
				allSatisfy: [ :each | each isKindOf: GtLFileContentsDomainObject ]).
	model := result model.
	self assert: model files size equals: 2.
	self assert: model files first path equals: fileOne pathString.
	self assert: model files first contents equals: 'First file'.
	self assert: model files second path equals: fileTwo pathString.
	self assert: model files second contents equals: 'Second file'.
	self assert: fileOne contents equals: 'First file'.
	self assert: fileTwo contents equals: 'Second file'.
	^ call ]
		ensure: [ fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteWithoutFiles [
	<gtExample>
	| tool call result |
	tool := GtLMagritteToolForFilesWrite new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model isErrorDomainObject.
	self assert: result model missingArgument equals: 'files'.
	^ call
]
