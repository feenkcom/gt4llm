"
Examples for GtLMagritteToolForPackageClasses.
"
Class {
	#name : #GtLMagritteToolForPackageClassesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForBlocReturns200 [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> (self gtDo: [ 'Bloc' ] gemstoneDo: [ 'Gt4LlmCore' ])
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames size equals: 200.
	self assert: targetObject mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForExistingPackage [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> (self gtDo: [ 'GToolkit-Boxer' ] gemstoneDo: [ String category ])
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: (targetObject foundClassNames includes: (self gtDo: [ 'GtArrayBox' ] gemstoneDo: [ 'String' ])).
	self assert: targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForPackageWithNoClasses [
	<gtExample>
	| call organizer packageName |
	self gtDo: [ ] gemstoneDo: [
		"GemStone categories exist only while they contain classes."
		call := self executeTool: GtLMagritteToolForPackageClasses new
			withArguments: { 'packageName' -> 'EmptyPackageWithNoClasses' } asDictionary.
		self assertMissingObject: call result targetObject
			withObjectName: 'EmptyPackageWithNoClasses'
			errorMessage: 'EmptyPackageWithNoClasses is not found'.
		^ call ].
	organizer := PackageOrganizer packageOrganizer.
	packageName := 'EmptyPackageWithNoClasses'.
	organizer ensurePackage: packageName asSymbol.
	[
		call := self
			executeTool: GtLMagritteToolForPackageClasses new
			withArguments: {
				'packageName' -> packageName
			} asDictionary.
		self assert: (call result targetObject isKindOf: GtLClassesSearchResult).
		self assert: call result targetObject foundClassNames equals: #().
		self assert: call result targetObject mayHaveMore not
	] ensure: [
		| package |
		package := organizer packageNamed: packageName asSymbol ifAbsent: [ nil ].
		package ifNotNil: [ organizer unregisterPackage: package ]
	].
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForUnknownPackage [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> 'NonExistingPackageName42'
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingPackageName42'
		errorMessage: 'NonExistingPackageName42 is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithEmptyPackageName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> ''
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'packageName'
		errorMessage: 'Missing argument called packageName'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithNilPackageName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('packageName')
		errorMessage: '@[packageName] string expected'.
	^ call
]
