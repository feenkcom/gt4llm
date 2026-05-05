Class {
	#name : #GtLMagritteToolForFilesGrepExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForDirectory [
	<gtExample>
	<noTest>
	| tool call directory fileOne fileTwo |
	directory := './tmp/GtLMagritteToolForFilesGrepDir' asFileReference.
	[ | targetObject |
		directory ensureCreateDirectory.
		fileOne := directory / 'one.txt'.
		fileTwo := directory / 'two.txt'.
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'Alpha beta' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'beta gamma' ].
		tool := GtLMagritteToolForFilesGrep new.
		call := self
			executeTool: tool
			withArguments: {
				'query' -> 'beta'.
				'filePath' -> { 'pathString' -> directory pathString } asDictionary.
				'fileNamePatterns' -> #('*.txt') } asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLGrepFilesMatches).
		self assert: targetObject files size equals: 2.
		self assert: (targetObject files anySatisfy: [ :each | each pathString = fileOne pathString ]).
		self assert: (targetObject files anySatisfy: [ :each | each pathString = fileTwo pathString ]).
		^ call ]
		ensure: [ directory exists ifTrue: [ directory deleteAll ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForExistingFiles [
	<gtExample>
	<noTest>
	| tool call fileOne |
	[ | targetObject |
		fileOne := 'GtLMagritteToolForFilesGrep_one.txt' asFileReference.
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'Alpha', OSPlatform current lineEnding, 'beta Gamma' ].
		tool := GtLMagritteToolForFilesGrep new.
		call := self
			executeTool: tool
			withArguments: { 'query' -> 'beta'.
				'filePath' -> { 'pathString' -> fileOne pathString } asDictionary } asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLGrepFilesMatches).
		self assert: targetObject query equals: 'beta'.
		self assert: targetObject files size equals: 1.
		self assert: targetObject files first pathString equals: fileOne pathString.
		self assert: targetObject files first ranges size equals: 1.
		self assert: targetObject files first ranges first startLine equals: 2.
		self assert: targetObject files first ranges first startIndex equals: 6.
		self assert: targetObject files first ranges first startColumn equals: 1.
		^ call ]
		ensure: [ fileOne exists ifTrue: [ fileOne delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForMissingFile [
	<gtExample>
	<noTest>
	| tool call missingPath targetObject |
	missingPath := (FileLocator temp / 'gt-llm-missing-file.txt') pathString.
	tool := GtLMagritteToolForFilesGrep new.
	call := self
		executeTool: tool
		withArguments: {
			'query' -> 'needle'.
			'filePath' -> { 'pathString' -> missingPath } asDictionary } asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	self assert: targetObject objectName = missingPath.
	^ call
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepForNestedDirectory [
	<gtExample>
	<noTest>
	| tool call root nested fileOne fileTwo |
	root := './tmp/GtLMagritteToolForFilesGrepRoot' asFileReference.
	[ | targetObject |
		root ensureCreateDirectory.
		nested := root / 'nested'.
		nested ensureCreateDirectory.
		fileOne := root / 'root.txt'.
		fileTwo := nested / 'nested.txt'.
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'alpha beta' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'beta gamma' ].
		tool := GtLMagritteToolForFilesGrep new.
		call := self
			executeTool: tool
			withArguments: {'query' -> 'beta'.
					'filePath' -> {'pathString' -> root pathString} asDictionary.
					'fileNamePatterns' -> #('*.txt')} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLGrepFilesMatches).
		self assert: targetObject files size equals: 2.
		self
			assert: (targetObject files anySatisfy: [ :each | each pathString = fileOne pathString ]).
		self
			assert: (targetObject files anySatisfy: [ :each | each pathString = fileTwo pathString ]).
		^ call ]
		ensure: [ root exists
				ifTrue: [ root allChildren reversed do: [ :child | child delete ].
					root exists ifTrue: [ root delete ] ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepWithFileNamePatterns [
	<gtExample>
	<noTest>
	| tool call directory fileOne fileTwo |
	directory := './tmp/GtLMagritteToolForFilesGrepPattern' asFileReference.
	[ | targetObject |
		directory ensureCreateDirectory.
		fileOne := directory / 'one.txt'.
		fileTwo := directory / 'two.md'.
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'alpha beta' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'beta gamma' ].
		tool := GtLMagritteToolForFilesGrep new.
		call := self
			executeTool: tool
			withArguments: {
				'query' -> 'beta'.
				'filePath' -> { 'pathString' -> directory pathString } asDictionary.
				'fileNamePatterns' -> #('*.md') } asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLGrepFilesMatches).
		self assert: targetObject files size equals: 1.
		self assert: targetObject files first pathString equals: fileTwo pathString.
		^ call ]
		ensure: [ directory exists ifTrue: [ directory deleteAll ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesGrepExamples >> filesGrepWithoutQuery [
	<gtExample>
	| tool call targetObject |
	tool := GtLMagritteToolForFilesGrep new.
	call := self
		executeTool: tool
		withArguments: { 'filePath' -> Dictionary new } asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	self assert: (targetObject isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: targetObject missingPropertyNames equals: #('pathString').
	self assert: targetObject path equals: #('filePath').
	^ call
]
