Class {
	#name : #GtLMagritteToolForFilesGrepExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForDirectory [
	<gtExample>
	| tool call result model directory fileOne fileTwo |
	directory := './tmp/GtLMagritteToolForFilesGrepDir' asFileReference.
	[ directory ensureCreateDirectory.
		fileOne := directory / 'one.txt'.
		fileTwo := directory / 'two.txt'.
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'Alpha beta' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'beta gamma' ].
		tool := GtLMagritteToolForFilesGrep new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'query' -> 'beta'.
			'filePath' -> { 'pathString' -> directory pathString } asDictionary.
			'fileNamePatterns' -> #('*.txt') } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteInputModel).
		model := result model.
		self assert: model files size equals: 2.
		self assert: (model files anySatisfy: [ :each | each pathString = fileOne pathString ]).
		self assert: (model files anySatisfy: [ :each | each pathString = fileTwo pathString ]).
		^ call ]
		ensure: [ directory exists ifTrue: [ directory deleteAll ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForExistingFiles [
	<gtExample>
	| tool call result model fileOne |
	[ fileOne := 'GtLMagritteToolForFilesGrep_one.txt' asFileReference.
	fileOne writeStreamDo: [ :stream | stream nextPutAll: 'Alpha', OSPlatform current lineEnding, 'beta Gamma' ].
	tool := GtLMagritteToolForFilesGrep new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'beta'.
		'filePath' -> { 'pathString' -> fileOne pathString } asDictionary } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 2.
	model := result model.
	self assert: model query equals: 'beta'.
	self assert: model files size equals: 1.
	self assert: model files first pathString equals: fileOne pathString.
	self assert: model files first ranges size equals: 1.
	self assert: model files first ranges first startLine equals: 2.
	self assert: model files first ranges first startIndex equals: 6.
	self assert: model files first ranges first startColumn equals: 1.
	^ call ]
		ensure: [ fileOne exists ifTrue: [ fileOne delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForMissingFile [
	<gtExample>
	| tool call result model missingPath |
	missingPath := (FileLocator temp / 'gt-llm-missing-file.txt') pathString.
	tool := GtLMagritteToolForFilesGrep new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'query' -> 'needle'.
		'filePath' -> { 'pathString' -> missingPath } asDictionary } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model objectName = missingPath.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForNestedDirectory [
	<gtExample>
	| tool call result model root nested fileOne fileTwo |
	root := './tmp/GtLMagritteToolForFilesGrepRoot' asFileReference.
	[ root ensureCreateDirectory.
		nested := root / 'nested'.
		nested ensureCreateDirectory.
		fileOne := root / 'root.txt'.
		fileTwo := nested / 'nested.txt'.
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'alpha beta' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'beta gamma' ].
		tool := GtLMagritteToolForFilesGrep new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'query' -> 'beta'.
			'filePath' -> { 'pathString' -> root pathString } asDictionary.
			'fileNamePatterns' -> #('*.txt') } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteInputModel).
		model := result model.
		self assert: model files size equals: 2.
		self assert: (model files anySatisfy: [ :each | each pathString = fileOne pathString ]).
		self assert: (model files anySatisfy: [ :each | each pathString = fileTwo pathString ]).
		^ call ]
		ensure: [
			root exists ifTrue: [
				root allChildren reversed do: [ :child | child delete ].
				root exists ifTrue: [ root delete ] ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepWithFileNamePatterns [
	<gtExample>
	| tool call result model directory fileOne fileTwo |
	directory := './tmp/GtLMagritteToolForFilesGrepPattern' asFileReference.
	[ directory ensureCreateDirectory.
		fileOne := directory / 'one.txt'.
		fileTwo := directory / 'two.md'.
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'alpha beta' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'beta gamma' ].
		tool := GtLMagritteToolForFilesGrep new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'query' -> 'beta'.
			'filePath' -> { 'pathString' -> directory pathString } asDictionary.
			'fileNamePatterns' -> #('*.md') } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteInputModel).
		model := result model.
		self assert: model files size equals: 1.
		self assert: model files first pathString equals: fileTwo pathString.
		^ call ]
		ensure: [ directory exists ifTrue: [ directory deleteAll ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepWithoutQuery [
	<gtExample>
	| tool call result |
	tool := GtLMagritteToolForFilesGrep new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'filePath' -> Dictionary new } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model isErrorDomainObject.
	self assert: result model missingArgument equals: 'query'.
	^ call
]
