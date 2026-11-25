"
Examples for GtLMagritteToolForClassRemoval.
"
Class {
	#name : #GtLMagritteToolForClassRemovalExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> assertNoBehaviorIsKeptBy: aChangeManager [
	"The undo and redo changes are built from definitions and names: no removed class stays alive through them"

	(aChangeManager instVarNamed: #undo) , (aChangeManager instVarNamed: #redo)
		do: [ :eachPerformedChange | 
			eachPerformedChange change gtAllChanges
				do: [ :eachChange | 
					eachChange class allInstVarNames
						do: [ :eachName | 
							| aValue |
							aValue := eachChange instVarNamed: eachName.
							self assert: aValue isBehavior not.
							self assert: (aValue isKindOf: ShiftClassBuilder) not ] ] ]
]

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> fixtureClassNamed: aSymbol with: aBuilderBlock [
	self removeClassNamedIfPresent: aSymbol.
	^ Smalltalk classInstaller
		make: [ :aBuilder | 
			aBuilder
				name: aSymbol;
				package: 'Gt4LlmCore-Examples'.
			aBuilderBlock value: aBuilder ]
]

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> performRemovalOf: aClassName [
	"The removal is undoable: keep it out of the global undo/redo history"

	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ self
				executeTool: GtLMagritteToolForClassRemoval new
				withArguments: {'className' -> aClassName} asDictionary ]
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refusalNamesAtMostTenClasses [
	"A class can have thousands of subclasses: the problem names a few of them"

	<gtExample>
	| aDescription someNames |
	aDescription := (GtLRemoveClassSpecification new classNameToRemove: 'Object')
			gtProblems first description.
	someNames := (aDescription copyAfter: $:) copyUpTo: $..
	self assert: (someNames substrings: ',') size equals: 10.
	self
		assert: (someNames
				endsWith: ' and ' , (Object subclasses size - 10) printString , ' more').
	^ aDescription
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseClassNeededByVirtualMachine [
	"Only ask for the problems: never run a removal of a kernel class"

	<gtExample>
	| someProblems |
	someProblems := (GtLRemoveClassSpecification new
			classNameToRemove: 'SmallInteger') gtProblems.
	self assert: someProblems size equals: 1.
	self
		assert: someProblems first description
		equals: 'SmallInteger is needed by the virtual machine and cannot be removed.'.
	^ someProblems
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseClassWithSubclass [
	<gtExample>
	| call aSuperclass aSubclass |
	[ aSuperclass := self
			fixtureClassNamed: #GtLClassRemovalExamplesSuperclass
			with: [ :aBuilder | aBuilder superclass: Object ].
	aSubclass := self
			fixtureClassNamed: #GtLClassRemovalExamplesSubclass
			with: [ :aBuilder | aBuilder superclass: aSuperclass ].

	call := self performRemovalOf: 'GtLClassRemovalExamplesSuperclass'.

	self
		assertProblem: call result targetObject
		withErrorMessage: 'GtLClassRemovalExamplesSuperclass has subclasses: GtLClassRemovalExamplesSubclass. Remove the subclasses first.'.
	self
		assert: (Smalltalk globals at: #GtLClassRemovalExamplesSuperclass) == aSuperclass.
	self assert: aSubclass superclass == aSuperclass ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesSubclass #GtLClassRemovalExamplesSuperclass) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseClassWithSubclassDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock expectedJson |
	call := self refuseClassWithSubclass.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	expectedJson := {'errorMessage'
				-> 'GtLClassRemovalExamplesSuperclass has subclasses: GtLClassRemovalExamplesSubclass. Remove the subclasses first.'}
			asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.

	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseOtherNameOfClass [
	"A global can hold a class under another name, for example a deprecated name: removing it would remove that class"

	<gtExample>
	| call aTarget |
	[ aTarget := self
			fixtureClassNamed: #GtLClassRemovalExamplesTarget
			with: [ :aBuilder | aBuilder superclass: Object ].
	Smalltalk globals at: #GtLClassRemovalExamplesAlias put: aTarget.

	call := self performRemovalOf: 'GtLClassRemovalExamplesAlias'.

	self
		assertProblem: call result targetObject
		withErrorMessage: 'GtLClassRemovalExamplesAlias is another name of GtLClassRemovalExamplesTarget. Remove a class by its own name.'.
	self assert: (Smalltalk globals at: #GtLClassRemovalExamplesTarget) == aTarget ]
		ensure: [ Smalltalk globals removeKey: #GtLClassRemovalExamplesAlias ifAbsent: [  ].
			self removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesTarget) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseSharedPoolWithUser [
	<gtExample>
	| call aPool aUser |
	[ aPool := self
			fixtureClassNamed: #GtLClassRemovalExamplesPool
			with: [ :aBuilder | 
				aBuilder
					superclass: SharedPool;
					sharedVariables: #(#SharedValue) ].
	aUser := self
			fixtureClassNamed: #GtLClassRemovalExamplesPoolUser
			with: [ :aBuilder | 
				aBuilder
					superclass: Object;
					sharedPools: 'GtLClassRemovalExamplesPool' ].

	call := self performRemovalOf: 'GtLClassRemovalExamplesPool'.

	self
		assertProblem: call result targetObject
		withErrorMessage: 'GtLClassRemovalExamplesPool is used as a shared pool by: GtLClassRemovalExamplesPoolUser. Remove them first.'.
	self assert: (aUser sharedPools includes: aPool) ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesPoolUser #GtLClassRemovalExamplesPool) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseTraitUsedByTrait [
	<gtExample>
	| call aTrait aUserTrait |
	[ aTrait := self
			fixtureClassNamed: #TGtLClassRemovalExamplesTrait
			with: [ :aBuilder | aBuilder beTrait ].
	aUserTrait := self
			fixtureClassNamed: #TGtLClassRemovalExamplesTraitUser
			with: [ :aBuilder | 
				aBuilder
					beTrait;
					traitComposition: aTrait ].

	call := self performRemovalOf: 'TGtLClassRemovalExamplesTrait'.

	self
		assertProblem: call result targetObject
		withErrorMessage: 'TGtLClassRemovalExamplesTrait is used as a trait by: TGtLClassRemovalExamplesTraitUser. Remove it from their trait compositions, or remove them, first.'.
	self assert: (aUserTrait includesTrait: aTrait) ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#TGtLClassRemovalExamplesTraitUser #TGtLClassRemovalExamplesTrait) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseTraitUsedOnClassSideOnly [
	<gtExample>
	| call aTrait aUser |
	[ aTrait := self
			fixtureClassNamed: #TGtLClassRemovalExamplesTrait
			with: [ :aBuilder | aBuilder beTrait ].
	aTrait classSide compile: 'classSideTraitMethod ^ 2' classified: 'examples'.
	aUser := self
			fixtureClassNamed: #GtLClassRemovalExamplesClassSideTraitUser
			with: [ :aBuilder | 
				aBuilder
					superclass: Object;
					classTraitComposition: aTrait classTrait ].
	self assert: (aTrait users includes: aUser) not.

	call := self performRemovalOf: 'TGtLClassRemovalExamplesTrait'.

	self
		assertProblem: call result targetObject
		withErrorMessage: 'TGtLClassRemovalExamplesTrait is used as a trait by: GtLClassRemovalExamplesClassSideTraitUser. Remove it from their trait compositions, or remove them, first.'.
	self assert: aUser classSideTraitMethod equals: 2 ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesClassSideTraitUser #TGtLClassRemovalExamplesTrait) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> refuseTraitWithClassUser [
	<gtExample>
	| call aTrait aUser |
	[ aTrait := self
			fixtureClassNamed: #TGtLClassRemovalExamplesTrait
			with: [ :aBuilder | aBuilder beTrait ].
	aTrait compile: 'traitMethod ^ 1' classified: 'examples'.
	aUser := self
			fixtureClassNamed: #GtLClassRemovalExamplesTraitUser
			with: [ :aBuilder | 
				aBuilder
					superclass: Object;
					traitComposition: aTrait ].

	call := self performRemovalOf: 'TGtLClassRemovalExamplesTrait'.

	self
		assertProblem: call result targetObject
		withErrorMessage: 'TGtLClassRemovalExamplesTrait is used as a trait by: GtLClassRemovalExamplesTraitUser. Remove it from their trait compositions, or remove them, first.'.
	self assert: (Smalltalk globals at: #TGtLClassRemovalExamplesTrait) == aTrait.
	self assert: (aUser includesTrait: aTrait).
	self assert: aUser new traitMethod equals: 1 ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesTraitUser #TGtLClassRemovalExamplesTrait) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassEmptyClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> ''
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: ''
		errorMessage: ' is not found'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassMissingArgument [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
		
	^ call
]

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassNilClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassUsingTrait [
	<gtExample>
	| call aTrait |
	[ aTrait := self
			fixtureClassNamed: #TGtLClassRemovalExamplesTrait
			with: [ :aBuilder | aBuilder beTrait ].
	aTrait compile: 'traitMethod ^ 1' classified: 'examples'.
	self
		fixtureClassNamed: #GtLClassRemovalExamplesTraitUser
		with: [ :aBuilder | 
			aBuilder
				superclass: Object;
				traitComposition: aTrait ].

	call := self performRemovalOf: 'GtLClassRemovalExamplesTraitUser'.

	self assert: (call result targetObject isKindOf: GtLClassRemovalResult).
	self
		assert: (Smalltalk globals includesKey: #GtLClassRemovalExamplesTraitUser) not.
	self assert: (Smalltalk globals at: #TGtLClassRemovalExamplesTrait) == aTrait.
	self assert: aTrait users isEmpty.
	self assert: (aTrait includesSelector: #traitMethod) ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesTraitUser #TGtLClassRemovalExamplesTrait) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassWhitespaceOnlyClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> '   '
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: '   '
		errorMessage: '    is not found'.
		
	^ call
]

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> removeClassesNamedIfPresent: someSymbols [
	someSymbols do: [ :each | self removeClassNamedIfPresent: each ].
	someSymbols do: [ :each | Undeclared removeKey: each ifAbsent: [  ] ]
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeExistingClass [
	<gtExample>
	| className call |
	className := #GtLMagritteToolForClassRemovalExamplesTemporary.
	[ | targetObject |
	self
		fixtureClassNamed: className
		with: [ :aBuilder | aBuilder superclass: Object ].
	call := self performRemovalOf: className asString.
	targetObject := call result targetObject.

	self assert: (targetObject isKindOf: GtLClassRemovalResult).
	self assert: targetObject removedClassName equals: className.
	self assert: targetObject status equals: 'removed'.
	self assert: (Smalltalk globals includesKey: className) not ]
		ensure: [ self removeClassesNamedIfPresent: {className} ].
	^ call
]

{ #category : #'examples - data views' }
GtLMagritteToolForClassRemovalExamples >> removeExistingClassDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock expectedJson |
	call := self removeExistingClass.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	expectedJson := {'removedClassName'
				-> 'GtLMagritteToolForClassRemovalExamplesTemporary'.
			'status' -> 'removed'} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.

	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeLeafSubclass [
	<gtExample>
	| call aSuperclass |
	[ aSuperclass := self
			fixtureClassNamed: #GtLClassRemovalExamplesSuperclass
			with: [ :aBuilder | aBuilder superclass: Object ].
	self
		fixtureClassNamed: #GtLClassRemovalExamplesSubclass
		with: [ :aBuilder | aBuilder superclass: aSuperclass ].

	call := self performRemovalOf: 'GtLClassRemovalExamplesSubclass'.

	self assert: (call result targetObject isKindOf: GtLClassRemovalResult).
	self
		assert: (Smalltalk globals includesKey: #GtLClassRemovalExamplesSubclass) not.
	self
		assert: (Smalltalk globals at: #GtLClassRemovalExamplesSuperclass) == aSuperclass.
	self assert: aSuperclass subclasses isEmpty ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesSubclass #GtLClassRemovalExamplesSuperclass) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeMetaclassName [
	<gtExample>
	| call |
	call := self performRemovalOf: 'Object class'.
	self
		assertProblem: call result targetObject
		withErrorMessage: 'Object class is the class side of Object. Remove Object instead.'.
	self assert: (Smalltalk globals at: #Object) == Object.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeNonClassGlobal [
	<gtExample>
	| call |
	call := self performRemovalOf: 'Smalltalk'.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'Smalltalk'
		errorMessage: 'Smalltalk is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeReferencedClass [
	"Methods of other classes that reference the class do not prevent its removal; they are left as they are"

	<gtExample>
	| call result aTarget aReferencer |
	[ aTarget := self
			fixtureClassNamed: #GtLClassRemovalExamplesTarget
			with: [ :aBuilder | aBuilder superclass: Object ].
	aTarget
		compile: 'itself ^ GtLClassRemovalExamplesTarget'
		classified: 'examples'.
	aTarget class
		compile: 'make ^ GtLClassRemovalExamplesTarget new'
		classified: 'examples'.
	aReferencer := self
			fixtureClassNamed: #GtLClassRemovalExamplesReferencer
			with: [ :aBuilder | aBuilder superclass: Object ].
	aReferencer
		compile: 'target ^ GtLClassRemovalExamplesTarget new'
		classified: 'examples'.
	aReferencer
		compile: 'targetInBlock ^ [ GtLClassRemovalExamplesTarget ] value'
		classified: 'examples'.
	aReferencer
		compile: 'targetName ^ #GtLClassRemovalExamplesTarget'
		classified: 'examples'.
	aReferencer class
		compile: 'target ^ GtLClassRemovalExamplesTarget'
		classified: 'examples'.

	call := self performRemovalOf: 'GtLClassRemovalExamplesTarget'.
	result := call result targetObject.

	self assert: (result isKindOf: GtLClassRemovalResult).
	self assert: result removedClassName equals: #GtLClassRemovalExamplesTarget.
	self assert: result status equals: 'removed'.
	self
		assert: (Smalltalk globals includesKey: #GtLClassRemovalExamplesTarget) not.
	self assert: (aReferencer includesSelector: #target) ]
		ensure: [ self
				removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesReferencer #GtLClassRemovalExamplesTarget) ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeUnknownClass [
	<gtExample>
	| call className |
	
	className := 'GtLMagritteToolForClassRemovalExamplesDoesNotExist'.
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> className
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: className
		errorMessage: className, ' is not found'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeUnusedTrait [
	<gtExample>
	| call |
	[ (self
		fixtureClassNamed: #TGtLClassRemovalExamplesTrait
		with: [ :aBuilder | aBuilder beTrait ])
		compile: 'traitMethod ^ 1'
		classified: 'examples'.

	call := self performRemovalOf: 'TGtLClassRemovalExamplesTrait'.

	self assert: (call result targetObject isKindOf: GtLClassRemovalResult).
	self
		assert: call result targetObject removedClassName
		equals: #TGtLClassRemovalExamplesTrait.
	self
		assert: (Smalltalk globals includesKey: #TGtLClassRemovalExamplesTrait) not ]
		ensure: [ self removeClassesNamedIfPresent: #(#TGtLClassRemovalExamplesTrait) ].
	^ call
]

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> snapshotOfClassNamed: aSymbol [
	^ (Smalltalk globals at: aSymbol ifAbsent: [ nil ])
		ifNil: [ #absent ]
		ifNotNil: [ :aClass | 
			{aClass definitionString.
				aClass class definitionString.
				{aClass.
					aClass class}
					collect: [ :eachBehavior | 
						eachBehavior localSelectors asSortedCollection asArray
							collect: [ :eachSelector | 
								{eachSelector.
									(eachBehavior >> eachSelector) protocolName.
									eachBehavior sourceCodeAt: eachSelector} ] ]} ]
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> undoRemovalOfClassUsingTrait [
	"Undo restores the class from its definition: the trait methods stay in the trait, the class side keeps its slot and methods.
	Undo and redo twice, and check that no removed class is kept by the undo history"

	<gtExample>
	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ :aChangeManager | 
			| aTrait aUser before call |
			[ aTrait := self
					fixtureClassNamed: #TGtLClassRemovalExamplesTrait
					with: [ :aBuilder | aBuilder beTrait ].
			aTrait compile: 'traitMethod ^ 1' classified: 'examples'.
			aUser := self
					fixtureClassNamed: #GtLClassRemovalExamplesTraitUser
					with: [ :aBuilder | 
						aBuilder
							superclass: Object;
							traitComposition: aTrait;
							slots: #(#value) ].
			aUser compile: 'value ^ value' classified: 'accessing'.
			aUser class instanceVariableNames: 'default'.
			aUser class compile: 'default ^ default' classified: 'accessing'.
			before := self snapshotOfClassNamed: #GtLClassRemovalExamplesTraitUser.

			call := self
					executeTool: GtLMagritteToolForClassRemoval new
					withArguments: {'className' -> 'GtLClassRemovalExamplesTraitUser'} asDictionary.
			self assert: (call result targetObject isKindOf: GtLClassRemovalResult).
			self assert: aChangeManager hasUndoableOperations.
			self assertNoBehaviorIsKeptBy: aChangeManager.

			2
				timesRepeat: [ aChangeManager undoChange.
					self
						assert: (self snapshotOfClassNamed: #GtLClassRemovalExamplesTraitUser)
						equals: before.
					self
						assert: ((Smalltalk globals at: #GtLClassRemovalExamplesTraitUser) includesTrait: aTrait).
					self
						assert: ((Smalltalk globals at: #GtLClassRemovalExamplesTraitUser)
								includesLocalSelector: #traitMethod) not.
					self assertNoBehaviorIsKeptBy: aChangeManager.

					aChangeManager redoChange.
					self
						assert: (Smalltalk globals includesKey: #GtLClassRemovalExamplesTraitUser) not.
					self assertNoBehaviorIsKeptBy: aChangeManager ] ]
				ensure: [ self
						removeClassesNamedIfPresent: #(#GtLClassRemovalExamplesTraitUser #TGtLClassRemovalExamplesTrait) ].
			call ]
]
