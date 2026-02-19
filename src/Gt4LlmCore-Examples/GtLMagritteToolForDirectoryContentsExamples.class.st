Class {
	#name : #GtLMagritteToolForDirectoryContentsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForExistingDirectory [
	<gtExample>
	| tool call result model tempDirectory root fileOne fileTwo subDirectory |
	tempDirectory := GtTemporaryDirectory new.
	root := tempDirectory reference.
	fileOne := root / 'one.txt'.
	fileTwo := root / 'two.txt'.
	subDirectory := root / 'sub'.
	[ fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		subDirectory ensureCreateDirectory.
		tool := GtLMagritteToolForDirectoryContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'directoryPath' -> root pathString } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteInputModel).
		model := result model.
		self assert: model directoryPath equals: root pathString.
		self assert: model files size equals: 2.
		self assert: (model files allSatisfy: [ :each | each isFile ]).
		self assert: (model files collect: #pathString) asSet equals: {fileOne pathString. fileTwo pathString} asSet.
		self assert: model directories size equals: 1.
		self assert: (model directories allSatisfy: [ :each | each isDirectory ]).
		self assert: model directories first pathString equals: subDirectory pathString.
		^ call ]
		ensure: [
			fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ].
			subDirectory exists ifTrue: [ subDirectory delete ].
			root exists ifTrue: [ root delete ] ]
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForFilePath [
	<gtExample>
	| tool call result model fileReference |
	fileReference := FileReference newTempFilePrefix: 'gt-llm-directory' suffix: '.txt'.
	[ fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Not a directory' ].
		tool := GtLMagritteToolForDirectoryContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'directoryPath' -> fileReference pathString } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteInputModel).
		model := result model.
		self assert: model isErrorDomainObject.
		self assert: model argumentName equals: 'directoryPath'.
		self assert: model argumentValue equals: fileReference pathString.
		self assert: model expectedArgumentValueKind equals: AbstractFileReference.
		^ call ]
		ensure: [ fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForMissingDirectory [
	<gtExample>
	| tool call result model missingPath |
	missingPath := (FileLocator temp / 'gt-llm-missing-directory') pathString.
	tool := GtLMagritteToolForDirectoryContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'directoryPath' -> missingPath } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model objectName equals: missingPath.
	^ call
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsWithoutPath [
	<gtExample>
	| tool call result |
	tool := GtLMagritteToolForDirectoryContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model isErrorDomainObject.
	self assert: result model missingArgument equals: 'directoryPath'.
	^ call
]
