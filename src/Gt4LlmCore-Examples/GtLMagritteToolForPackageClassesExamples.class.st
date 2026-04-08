"
Examples for GtLMagritteToolForPackageClasses.
"
Class {
	#name : #GtLMagritteToolForPackageClassesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForBlocReturns200 [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> 'Bloc'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames size equals: 200.
	self assert: targetObject mayHaveMore.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForExistingPackage [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> 'GToolkit-Boxer'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: (targetObject foundClassNames includes: 'GtArrayBox').
	self assert: targetObject mayHaveMore not.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForPackageWithNoClasses [
	<gtExample>
	| targetObject organizer packageName |
	organizer := PackageOrganizer packageOrganizer.
	packageName := 'EmptyPackageWithNoClasses'.
	organizer ensurePackage: packageName asSymbol.
	[
		targetObject := self
			executeTool: GtLMagritteToolForPackageClasses new
			withArguments: {
				'packageName' -> packageName
			} asDictionary.
		
		self assert: (targetObject isKindOf: GtLClassesSearchResult).
		self assert: targetObject foundClassNames equals: #().
		self assert: targetObject mayHaveMore not
	] ensure: [
		| package |
		package := organizer packageNamed: packageName asSymbol ifAbsent: [ nil ].
		package ifNotNil: [ organizer unregisterPackage: package ]
	].
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForUnknownPackage [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> 'NonExistingPackageName42'
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: 'NonExistingPackageName42'
		errorMessage: 'NonExistingPackageName42 is not found'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithEmptyPackageName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> ''
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'packageName'
		errorMessage: 'Missing argument called packageName'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithNilPackageName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForPackageClasses new
		withArguments: {
			'packageName' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('packageName')
		errorMessage: '@[packageName] string expected'.
	
	^ targetObject
]
