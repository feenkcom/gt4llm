Class {
	#name : #GtLMagritteToolForDirectoryContentsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - data views' }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData |
	call := self directoryContentsForExistingDirectory.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #directoryPath) isNotNil.
	self assert: (jsonData at: #files) isNotEmpty.
	self assert: (jsonData at: #directories) isNotEmpty.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForDirectoryWithOnlyFiles [
	<gtExample>
	| tempDirectory root fileOne fileTwo |
	tempDirectory := GtTemporaryDirectory new.
	root := tempDirectory reference.
	fileOne := root / 'one.txt'.
	fileTwo := root / 'two.md'.
	[ | tool call targetObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second' ].
		tool := GtLMagritteToolForDirectoryContents new.
		call := self
			executeTool: tool
			withArguments: { 'directoryPath' -> root pathString } asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLDirectoryContents).
		self assert: targetObject files size equals: 2.
		self assert: targetObject directories isEmpty.
		^ call ]
		ensure: [
			fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ].
			root exists ifTrue: [ root delete ] ]
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForDirectoryWithOnlySubdirectories [
	<gtExample>
	| tempDirectory root subDirOne subDirTwo |
	tempDirectory := GtTemporaryDirectory new.
	root := tempDirectory reference.
	subDirOne := root / 'dirA'.
	subDirTwo := root / 'dirB'.
	[ | tool call targetObject |
		subDirOne ensureCreateDirectory.
		subDirTwo ensureCreateDirectory.
		tool := GtLMagritteToolForDirectoryContents new.
		call := self
			executeTool: tool
			withArguments: { 'directoryPath' -> root pathString } asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLDirectoryContents).
		self assert: targetObject files isEmpty.
		self assert: targetObject directories size equals: 2.
		^ call ]
		ensure: [
			subDirOne exists ifTrue: [ subDirOne delete ].
			subDirTwo exists ifTrue: [ subDirTwo delete ].
			root exists ifTrue: [ root delete ] ]
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForEmptyDirectory [
	<gtExample>
	| tempDirectory root |
	tempDirectory := GtTemporaryDirectory new.
	root := tempDirectory reference.
	[ | tool call targetObject |
		tool := GtLMagritteToolForDirectoryContents new.
		call := self
			executeTool: tool
			withArguments: { 'directoryPath' -> root pathString } asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLDirectoryContents).
		self assert: targetObject directoryPath equals: root pathString.
		self assert: targetObject files isEmpty.
		self assert: targetObject directories isEmpty.
		^ call ]
		ensure: [ root exists ifTrue: [ root delete ] ]
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForExistingDirectory [
	<gtExample>
	| tempDirectory root fileOne fileTwo subDirectory |
	tempDirectory := GtTemporaryDirectory new.
	root := tempDirectory reference.
	fileOne := root / 'one.txt'.
	fileTwo := root / 'two.txt'.
	subDirectory := root / 'sub'.
	[ | tool call targetObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		subDirectory ensureCreateDirectory.
		tool := GtLMagritteToolForDirectoryContents new.
		call := self
			executeTool: tool
			withArguments: { 'directoryPath' -> root pathString } asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLDirectoryContents).
		self assert: targetObject directoryPath equals: root pathString.
		self assert: targetObject files size equals: 2.
		self assert: (targetObject files allSatisfy: [ :each | each isFile ]).
		self assert: (targetObject files collect: #pathString) asSet equals: {fileOne pathString. fileTwo pathString} asSet.
		self assert: targetObject directories size equals: 1.
		self assert: (targetObject directories allSatisfy: [ :each | each isDirectory ]).
		self assert: targetObject directories first pathString equals: subDirectory pathString.
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
	| fileReference |
	fileReference := FileReference newTempFilePrefix: 'gt-llm-directory' suffix: '.txt'.
	[ | tool call |
		fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Not a directory' ].
		tool := GtLMagritteToolForDirectoryContents new.
		call := self
			executeTool: tool
			withArguments: { 'directoryPath' -> fileReference pathString } asDictionary.
		self 
			assertIncorrectArgumentType: call result targetObject 
			withArgumentName: 'directoryPath' 
			argumentValue: fileReference pathString 
			expectedKind: AbstractFileReference.
		^ call ]
		ensure: [ fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForMissingDirectory [
	<gtExample>
	| tool call missingPath |
	missingPath := (FileLocator temp / 'gt-llm-missing-directory') pathString.
	tool := GtLMagritteToolForDirectoryContents new.
	call := self
		executeTool: tool
		withArguments: { 'directoryPath' -> missingPath } asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: missingPath 
		errorMessage: missingPath, ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsWithEmptyPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForDirectoryContents new.
	call := self
		executeTool: tool
		withArguments: { 'directoryPath' -> '' } asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: '' 
		errorMessage: ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsWithNilPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForDirectoryContents new.
	call := self
		executeTool: tool
		withArguments: { 'directoryPath' -> nil } asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('directoryPath') 
		errorMessage: '@[directoryPath] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsWithoutPath [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForDirectoryContents new.
	call := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('directoryPath') 
		path: #(nil) 
		errorMessage: 'required properties missing [directoryPath]'.
	^ call
]
