Class {
	#name : #GtLMagritteToolForFilesWriteExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForDirectoryPath [
	<gtExample>
	| tempDirectory directoryPath |
	tempDirectory := GtTemporaryDirectory new.
	directoryPath := tempDirectory reference pathString.
	[ | tool call result domainObject |
		tool := GtLMagritteToolForFilesWrite new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'files' -> { {'path' -> directoryPath. 'contents' -> 
				'Not a file' asByteArray base64Encoded} asDictionary } asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self 
			assertIncorrectArgumentType: domainObject 
			withArgumentName: 'path' 
			argumentValue: directoryPath 
			expectedKind: AbstractFileReference.
		^ domainObject ]
		ensure: [ tempDirectory reference exists ifTrue: [ tempDirectory reference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForExistingFiles [
	<gtExample>
	| fileOne fileTwo |
	fileOne := FileReference
			newTempFilePrefix: 'GtLMagritteToolForFilesWrite'
			suffix: 'one.txt'.
	fileTwo := FileReference
			newTempFilePrefix: 'GtLMagritteToolForFilesWrite'
			suffix: 'two.txt'.
	[ | tool call result domainObject |
		tool := GtLMagritteToolForFilesWrite new.
		call := GtLFunctionToolCall new.
		call
			rawArguments: {'files'
					-> {{'path' -> fileOne pathString.
								'contents' -> 'First file' asByteArray base64Encoded} asDictionary.
							{'path' -> fileTwo pathString.
								'contents' -> 'Second file' asByteArray base64Encoded} asDictionary} asArray} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		self assert: call arguments size equals: 1.
		self
			assert: (call arguments anyOne
					allSatisfy: [ :each | each isKindOf: GtLFileContentsDomainObject ]).
		domainObject := result targetObject.
		self assert: domainObject files size equals: 2.
		self assert: domainObject files first path equals: fileOne pathString.
		self assert: domainObject files first contents equals: 'First file' asByteArray base64Encoded.
		self assert: domainObject files second path equals: fileTwo pathString.
		self assert: domainObject files second contents equals: 'Second file' asByteArray base64Encoded.
		self assert: fileOne contents equals: 'First file'.
		self assert: fileTwo contents equals: 'Second file'.
		^ domainObject ]
		ensure: [ fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteForMissingParentDirectory [
	<gtExample>
	| tempDirectory nestedFile parentDirectory |
	tempDirectory := GtTemporaryDirectory new.
	parentDirectory := tempDirectory reference / 'nested'.
	nestedFile := parentDirectory / 'child.txt'.
	[ | tool call result domainObject |
		tool := GtLMagritteToolForFilesWrite new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'files' -> { {'path' -> nestedFile pathString. 'contents' -> 'Nested file' asByteArray base64Encoded} asDictionary } asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: domainObject files size equals: 1.
		self assert: domainObject files first path equals: nestedFile pathString.
		self assert: domainObject files first contents equals: 'Nested file' asByteArray base64Encoded.
		self assert: parentDirectory exists.
		^ domainObject ]
		ensure: [
			nestedFile exists ifTrue: [ nestedFile delete ].
			parentDirectory exists ifTrue: [ parentDirectory delete ].
			tempDirectory reference exists ifTrue: [ tempDirectory reference delete ] ]
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteWithEmptyPath [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesWrite new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'files' -> { {'path' -> ''. 'contents' -> 'Empty' asByteArray base64Encoded} asDictionary } asArray } asDictionary.
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
GtLMagritteToolForFilesWriteExamples >> filesWriteWithNilFiles [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesWrite new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'files' -> { nil } asArray } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('files' 1) 
		errorMessage: '@[files/1] object expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForFilesWriteExamples >> filesWriteWithoutFiles [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForFilesWrite new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('files') 
		path: #(nil) 
		errorMessage: 'required properties missing [files]'.
	^ domainObject
]
