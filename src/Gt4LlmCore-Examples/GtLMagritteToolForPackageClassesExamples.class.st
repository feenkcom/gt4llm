"
Examples for GtLMagritteToolForPackageClasses.
"
Class {
	#name : #GtLMagritteToolForPackageClassesExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForBlocReturns200 [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> 'Bloc' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassesSearchResult).
	self assert: domainObject foundClassNames size equals: 200.
	self assert: domainObject mayHaveMore.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForExistingPackage [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> 'GToolkit-Boxer' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassesSearchResult).
	self assert: (domainObject foundClassNames includes: 'GtArrayBox').
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForPackageWithNoClasses [
	<gtExample>
	| tool call result domainObject organizer packageName |
	tool := GtLMagritteToolForPackageClasses new.
	organizer := PackageOrganizer packageOrganizer.
	packageName := 'EmptyPackageWithNoClasses'.
	organizer ensurePackage: packageName asSymbol.
	[
		call := GtLFunctionToolCall new.
		call rawArguments: { 'packageName' -> packageName } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLClassesSearchResult).
		self assert: domainObject foundClassNames equals: #().
		self assert: domainObject mayHaveMore not
	] ensure: [
		| package |
		package := organizer packageNamed: packageName asSymbol ifAbsent: [ nil ].
		package ifNotNil: [ organizer unregisterPackage: package ]
	].
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForPackageClassesExamples >> packageClassesForUnknownPackage [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> 'NonExistingPackageName42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'NonExistingPackageName42' 
		errorMessage: 'NonExistingPackageName42 is not found'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithEmptyPackageName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingArgument: domainObject 
		withArgumentName: 'packageName' 
		errorMessage: 'Missing argument called packageName'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithNilPackageName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('packageName') 
		errorMessage: '@[packageName] string expected'.
	^ domainObject
]
