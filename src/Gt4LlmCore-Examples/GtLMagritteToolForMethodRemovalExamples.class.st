"
Examples for GtLMagritteToolForMethodRemoval.
"
Class {
	#name : #GtLMagritteToolForMethodRemovalExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> createSubjectClass [
	self removeClassNamedIfPresent: self subjectClassName.
	^ ((Object << self subjectClassName)
		slots: {};
		package: 'Gt4LlmCore-Examples') install
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> createSubjectSubclassOf: aClass [
	self removeClassNamedIfPresent: self subjectSubclassName.
	^ ((aClass << self subjectSubclassName)
		slots: {};
		package: 'Gt4LlmCore-Examples') install
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> removeClassNamedIfPresent: aSymbol [

	"Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]"
	aSymbol asSymbol asClassIfPresent:
		[ :cls | cls removeFromSystem ].
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeClassSideMethod [
	<gtExample>
	| call |
	[ | class methodSelector targetObject |
	class := self createSubjectClass.
	methodSelector := #temporaryClassMethod.
	class class compile: 'temporaryClassMethod ^ 21'.
	call := self
			executeTool: GtLMagritteToolForMethodRemoval new
			withArguments: {'methodDescriptor'
						-> {'methodClassName' -> class name asString.
								'methodName' -> methodSelector asString.
								'classSide' -> true} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodRemovalResult).
	self assert: targetObject status equals: 'removed'.
	self
		assert: targetObject removedMethod methodName
		equals: methodSelector asString.
	self assert: targetObject removedMethod isClassSide.
	self
		assert: targetObject targetClass currentClassName
		equals: class name.
	self assert: (class class includesSelector: methodSelector) not ]
		ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeClassSideTraitProvidedMethod [
	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject |
			call := self
					removeMethodNamed: #classTraitMethod
					inClassNamed: subjects traitUser name
					classSide: true.
			targetObject := call result targetObject.
			self assert: (targetObject isKindOf: GtLMissingTraitMethodDomainObject).
			self
				assert: targetObject definingMethodReference methodClassName
				equals: subjects trait name asString.
			self assert: targetObject definingMethodReference isClassSide.
			self assert: subjects traitUser classTraitMethod equals: 43.
			call ]
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeConflictingTraitMethod [
	"A conflict between two traits is not removed; the error names both trait methods"

	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject |
			call := self
					removeMethodNamed: #traitMethod
					inClassNamed: subjects conflictingTraitsUser name
					classSide: false.
			targetObject := call result targetObject.
			self
				assert: targetObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self assert: targetObject conflictingMethodReferences size equals: 2.
			self assert: (subjects conflictingTraitsUser includesSelector: #traitMethod).
			call ]
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeInheritedClassSideMethod [
	<gtExample>
	| call |
	[ | class subclass targetObject expectedSignature |
	class := self createSubjectClass.
	subclass := self createSubjectSubclassOf: class.
	class class compile: 'temporaryInheritedClassMethod ^ 42'.
	call := self
			removeMethodNamed: #temporaryInheritedClassMethod
			inClassNamed: subclass name
			classSide: true.
	targetObject := call result targetObject.
	expectedSignature := subclass name asString
			, ' class>>#temporaryInheritedClassMethod'.
	self
		assertMissingObject: targetObject
		withObjectName: expectedSignature
		errorMessage: expectedSignature
				, ' is not defined in its own class: it is inherited. Its source is '
				, class name asString , ' class>>#temporaryInheritedClassMethod'.
	self assert: targetObject definingMethodReference isClassSide.
	self assert: (class class includesSelector: #temporaryInheritedClassMethod) ]
		ensure: [ self removeSubjectClasses ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeInheritedInstanceMethod [
	<gtExample>
	| call |
	[ | class subclass targetObject expectedSignature |
	class := self createSubjectClass.
	subclass := self createSubjectSubclassOf: class.
	class compile: 'temporaryInheritedMethod ^ 42'.
	call := self
			removeMethodNamed: #temporaryInheritedMethod
			inClassNamed: subclass name
			classSide: false.
	targetObject := call result targetObject.
	expectedSignature := subclass name asString , '>>#temporaryInheritedMethod'.
	self
		assertMissingObject: targetObject
		withObjectName: expectedSignature
		errorMessage: expectedSignature
				, ' is not defined in its own class: it is inherited. Its source is '
				, class name asString , '>>#temporaryInheritedMethod'.
	self assert: (targetObject isKindOf: GtLMissingInheritedMethodDomainObject).
	self
		assert: targetObject definingMethodReference methodClassName
		equals: class name asString.
	self assert: (class includesSelector: #temporaryInheritedMethod) ]
		ensure: [ self removeSubjectClasses ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeInstanceMethod [
	<gtExample>
	| call |
	[
		| class methodSelector targetObject |
		class := self createSubjectClass.
		methodSelector := #temporaryInstanceMethod.
		class compile: 'temporaryInstanceMethod ^ 42'.
		call := self
			executeTool: GtLMagritteToolForMethodRemoval new
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodRemovalResult).
		self assert: targetObject status equals: 'removed'.
		self assert: targetObject removedMethod methodName equals: methodSelector asString.
		self assert: targetObject removedMethod methodClassName equals: class name asString.
		self assert: (class includesSelector: methodSelector) not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeInstanceMethodDataViewSerialization [
	"A removal result names the removed method, so that each result can be matched to its request"

	<gtExample>
	| dataBlock jsonData removedReference |
	dataBlock := (self removeInstanceMethod result targetObject
			llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'status') equals: 'removed'.
	removedReference := jsonData at: 'targetMethodReference'.
	self
		assert: (removedReference at: 'methodClassName')
		equals: self subjectClassName asString.
	self
		assert: (removedReference at: 'methodName')
		equals: 'temporaryInstanceMethod'.
	self assert: (removedReference at: 'classSide') equals: false.
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodFromTrait [
	"Removing a method from a trait removes it, and its aliases, from the classes that use the trait, except where a class overrides it"

	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject |
			subjects composedTraitUser compile: 'traitMethod ^ 7'.
			call := self
					removeMethodNamed: #traitMethod
					inClassNamed: subjects trait name
					classSide: false.
			targetObject := call result targetObject.
			self assert: (targetObject isKindOf: GtLMethodRemovalResult).
			self assert: targetObject status equals: 'removed'.
			self
				assert: targetObject removedMethod methodClassName
				equals: subjects trait name asString.
			self assert: (subjects trait includesSelector: #traitMethod) not.
			self assert: (subjects traitUser includesSelector: #traitMethod) not.
			self assert: (subjects traitUser includesSelector: #aliasedTraitMethod) not.
			self assert: (subjects traitUserSubclass canUnderstand: #traitMethod) not.
			self assert: subjects composedTraitUser new traitMethod equals: 7.
			call ]
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodFromUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodRemoval new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'NonExistingClassName42'.
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: 'NonExistingClassName42' 
		errorMessage: 'NonExistingClassName42 is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodMissingArgument [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodRemoval new
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodDescriptor') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptor]'.
	^ call
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> removeMethodNamed: aSelector inClassNamed: aClassName classSide: aBoolean [
	^ self
		executeTool: GtLMagritteToolForMethodRemoval new
		withArguments: {'methodDescriptor'
					-> {'methodClassName' -> aClassName asString.
							'methodName' -> aSelector asString.
							'classSide' -> aBoolean} asDictionary} asDictionary
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodsReportsEachMethod [
	<gtExample>
	| call |
	[ | class subclass targetObject |
	class := self createSubjectClass.
	subclass := self createSubjectSubclassOf: class.
	class compile: 'temporaryInheritedMethod ^ 1'.
	subclass compile: 'temporaryOwnMethod ^ 2'.
	call := self
			executeTool: GtLMagritteToolForMethodsRemoval new
			withArguments: {'methods'
						-> {{'methodClassName' -> subclass name asString.
									'methodName' -> 'temporaryOwnMethod'.
									'classSide' -> false} asDictionary.
								{'methodClassName' -> subclass name asString.
									'methodName' -> 'temporaryInheritedMethod'.
									'classSide' -> false} asDictionary.
								{'methodClassName' -> subclass name asString.
									'methodName' -> 'temporaryUnknownMethod'.
									'classSide' -> false} asDictionary} asArray} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsRemovalResult).
	self assert: targetObject methods size equals: 3.
	self assert: targetObject methods first status equals: 'removed'.
	self
		assert: (targetObject methods second isKindOf: GtLMissingInheritedMethodDomainObject).
	self assert: targetObject methods third class equals: GtLMissingDomainObject.
	self assert: (subclass includesSelector: #temporaryOwnMethod) not.
	self assert: (class includesSelector: #temporaryInheritedMethod) ]
		ensure: [ self removeSubjectClasses ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeOverridingMethod [
	<gtExample>
	| call |
	[ | class subclass targetObject |
	class := self createSubjectClass.
	subclass := self createSubjectSubclassOf: class.
	class compile: 'temporaryOverriddenMethod ^ 1'.
	subclass compile: 'temporaryOverriddenMethod ^ 2'.
	call := self
			removeMethodNamed: #temporaryOverriddenMethod
			inClassNamed: subclass name
			classSide: false.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodRemovalResult).
	self assert: targetObject status equals: 'removed'.
	self
		assert: targetObject removedMethod methodClassName
		equals: subclass name asString.
	self assert: (subclass includesSelector: #temporaryOverriddenMethod) not.
	self assert: (class includesSelector: #temporaryOverriddenMethod).
	self assert: targetObject existsInImage not.
	self assert: targetObject currentMethodSourceCode equals: '' ]
		ensure: [ self removeSubjectClasses ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeOverridingTraitMethod [
	"Removing a local override of a trait method makes the trait method visible again"

	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject |
			subjects traitUser compile: 'traitMethod ^ 7'.
			call := self
					removeMethodNamed: #traitMethod
					inClassNamed: subjects traitUser name
					classSide: false.
			targetObject := call result targetObject.
			self assert: (targetObject isKindOf: GtLMethodRemovalResult).
			self assert: targetObject status equals: 'removed'.
			self assert: (subjects traitUser includesLocalSelector: #traitMethod) not.
			self assert: subjects traitUser new traitMethod equals: 42.
			call ]
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> removeSubjectClasses [
	self removeClassNamedIfPresent: self subjectSubclassName.
	self removeClassNamedIfPresent: self subjectClassName
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeTraitProvidedMethod [
	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject expectedSignature |
			call := self
					removeMethodNamed: #traitMethod
					inClassNamed: subjects traitUser name
					classSide: false.
			targetObject := call result targetObject.
			expectedSignature := subjects traitUser name asString , '>>#traitMethod'.
			self
				assertMissingObject: targetObject
				withObjectName: expectedSignature
				errorMessage: expectedSignature
						, ' is not defined in its own class: it is provided by a trait. Its source is '
						, subjects trait name asString , '>>#traitMethod'.
			self assert: targetObject class equals: GtLMissingTraitMethodDomainObject.
			self assert: (subjects trait includesSelector: #traitMethod).
			self assert: subjects traitUser new traitMethod equals: 42.
			call ]
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| call |
	[
		| class methodSelector expectedSignature |
		class := self createSubjectClass.
		methodSelector := #methodThatDoesNotExist.
		call := self
			executeTool: GtLMagritteToolForMethodRemoval new
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		expectedSignature := class name asString , '>>#' , methodSelector asString.
		self 
			assertMissingObject: call result targetObject 
			withObjectName: expectedSignature 
			errorMessage: expectedSignature , ' is not found'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> subjectClassName [
	^ #GtLMagritteToolForMethodRemovalExamplesSubject
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> subjectSubclassName [
	^ #GtLMagritteToolForMethodRemovalExamplesSubjectSubclass
]
