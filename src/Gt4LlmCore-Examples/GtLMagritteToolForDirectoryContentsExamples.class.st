Class {
	#name : #GtLMagritteToolForDirectoryContentsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self directoryContentsForExistingDirectory.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
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
	[ | tool call result domainObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second' ].
		tool := GtLMagritteToolForDirectoryContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'directoryPath' -> root pathString } asDictionary.
		result := tool performToolCall: call.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLDirectoryContents).
		self assert: domainObject files size equals: 2.
		self assert: domainObject directories isEmpty.
		^ domainObject ]
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
	[ | tool call result domainObject |
		subDirOne ensureCreateDirectory.
		subDirTwo ensureCreateDirectory.
		tool := GtLMagritteToolForDirectoryContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'directoryPath' -> root pathString } asDictionary.
		result := tool performToolCall: call.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLDirectoryContents).
		self assert: domainObject files isEmpty.
		self assert: domainObject directories size equals: 2.
		^ domainObject ]
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
	[ | tool call result domainObject |
		tool := GtLMagritteToolForDirectoryContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'directoryPath' -> root pathString } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLDirectoryContents).
		self assert: domainObject directoryPath equals: root pathString.
		self assert: domainObject files isEmpty.
		self assert: domainObject directories isEmpty.
		^ domainObject ]
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
	[ | tool call result domainObject |
		fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		subDirectory ensureCreateDirectory.
		tool := GtLMagritteToolForDirectoryContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'directoryPath' -> root pathString } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLDirectoryContents).
		self assert: domainObject directoryPath equals: root pathString.
		self assert: domainObject files size equals: 2.
		self assert: (domainObject files allSatisfy: [ :each | each isFile ]).
		self assert: (domainObject files collect: #pathString) asSet equals: {fileOne pathString. fileTwo pathString} asSet.
		self assert: domainObject directories size equals: 1.
		self assert: (domainObject directories allSatisfy: [ :each | each isDirectory ]).
		self assert: domainObject directories first pathString equals: subDirectory pathString.
		^ domainObject ]
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
	[ | tool call result domainObject |
		fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Not a directory' ].
		tool := GtLMagritteToolForDirectoryContents new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'directoryPath' -> fileReference pathString } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self 
			assertIncorrectArgumentType: domainObject 
			withArgumentName: 'directoryPath' 
			argumentValue: fileReference pathString 
			expectedKind: AbstractFileReference.
		^ domainObject ]
		ensure: [ fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsForMissingDirectory [
	<gtExample>
	| tool call result domainObject missingPath |
	missingPath := (FileLocator temp / 'gt-llm-missing-directory') pathString.
	tool := GtLMagritteToolForDirectoryContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'directoryPath' -> missingPath } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: missingPath 
		errorMessage: missingPath, ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsWithEmptyPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForDirectoryContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'directoryPath' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: '' 
		errorMessage: ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsWithNilPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForDirectoryContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'directoryPath' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('directoryPath') 
		errorMessage: '@[directoryPath] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForDirectoryContentsExamples >> directoryContentsWithoutPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForDirectoryContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('directoryPath') 
		path: #(nil) 
		errorMessage: 'required properties missing [directoryPath]'.
	^ domainObject
]
