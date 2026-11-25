Class {
	#name : #GtLToolForApplyRefactoringExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #private }
GtLToolForApplyRefactoringExamples >> addClassTransformationNamed: aClassName in: aPackageName [
	^ Dictionary new
		at: 'AddClass'
			put: (Dictionary new
					at: 'newClassName' put: aClassName asString;
					at: 'superclassName' put: 'Object';
					at: 'packageName' put: aPackageName asString;
					at: 'slotNames' put: 'first second';
					at: 'tagName' put: '';
					yourself);
		yourself
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> addMethodTransformationTo: aClassName [
	^(Dictionary new)
		at: 'AddMethod'
			put: ((Dictionary new)
					at: 'methodClassName' put: aClassName;
					at: 'protocolName' put: 'examples';
					at: 'sourceCodeOfMethodToAdd' put: 'appliedRefactoringMethod ^ 42';
					yourself);
		yourself
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyAddClass [
	"The applied refactoring reports the definition of the added class as its preview showed it. The class is added to a temporary package"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| objectStorage objectId call targetObject newClassName newClass previewedDefinition appliedDefinition |
			newClassName := aRootClass name , 'Added'.
			objectStorage := GtLObjectStorage new.
			objectId := self
					previewTransformation: (self addClassTransformationNamed: newClassName in: aRootClass package name)
					in: objectStorage.
			previewedDefinition := (objectStorage objectAt: objectId) changes first
					newSource.
			call := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: objectId)
					inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
			targetObject := self modelOf: call.
			self assert: targetObject class equals: GtLRefactoringResult.
			self assert: targetObject status equals: 'applied'.
			self assert: targetObject changesCount equals: 1.
			self assert: targetObject preview == (objectStorage objectAt: objectId).
			self assert: targetObject preview isApplied.
			newClass := Smalltalk globals classNamed: newClassName.
			self assert: newClass notNil.
			self assert: newClass superclass equals: Object.
			self assert: newClass instVarNames asArray equals: #(#first #second).
			self assert: newClass package equals: aRootClass package.
			appliedDefinition := (targetObject codeChangeResults
					detect: [ :each | each isKindOf: GtLClassModificationResult ]) llmNewSource.
			self assert: appliedDefinition equals: previewedDefinition.
			call ]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyAddMethod [
	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| objectStorage objectId call targetObject |
			objectStorage := GtLObjectStorage new.
			objectId := self previewAddMethodTo: aLeafClass in: objectStorage.
			call := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: objectId)
					inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
			targetObject := self modelOf: call.
			self assert: targetObject class equals: GtLRefactoringResult.
			self assert: targetObject status equals: 'applied'.
			self assert: targetObject changesCount equals: 1.
			self assert: targetObject preview == (objectStorage objectAt: objectId).
			self assert: targetObject preview isApplied.
			self
				assert: (aLeafClass >> #appliedRefactoringMethod) sourceCode
				equals: 'appliedRefactoringMethod ^ 42'.
			call ]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyAddMethodWithoutChangesInResponse [
	"With includeChanges false, the response only tells the status and the objectId of the stored result: the code changes are not listed, but the result keeps them"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| objectStorage objectId call report result arguments json |
			objectStorage := GtLObjectStorage new.
			objectId := self previewAddMethodTo: aLeafClass in: objectStorage.
			arguments := self argumentsWithObjectId: objectId.
			arguments at: 'displayOptions' put: {'includeChanges' -> false} asDictionary.
			call := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: arguments
					inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
			report := call result targetObject.
			self assert: report class equals: GtLRefactoringResultReport.
			self
				assert: report displayOptions class
				equals: GtLRefactoringResultDisplayOptions.
			self assert: report includesChanges not.
			result := self modelOf: call.
			self assert: result status equals: 'applied'.
			self assert: result codeChangeResults size equals: 1.
			json := report llmJsonObject.
			self
				assert: json keys asArray
				equals: #('status' 'refactoringName' 'refactoringDescription' 'changesCount' 'objectId').
			self assert: (json at: 'objectId') equals: result objectId.
			self assert: (json at: 'objectId') ~= objectId.
			self assert: (objectStorage objectAt: result objectId) == result.
			self assert: (aLeafClass includesSelector: #appliedRefactoringMethod).
			call ]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyAfterClassRemoval [
	"Applying fails when the class of a previewed method was removed in the meantime.
	The result is then marked as failed and holds the frozen exception.
	The preview counts as applied: applying it again is refused, and the refusal says to preview again to retry"

	<gtExample>
	| environment objectStorage objectId context call targetObject secondCall |
	environment := GtPharoDummyEnvironment withPackages: 1 classes: 1.
	objectStorage := GtLObjectStorage new.
	context := GtLToolExecutionContext new objectStorage: objectStorage.
	[ objectId := self
			previewTransformation: (self addMethodTransformationTo: environment anyDummyClass className asString)
			in: objectStorage ] ensure: [ self removeDummies: environment ].
	call := GtRefactoryChangeManager
			isolatedInstanceDuring: [ self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: objectId)
					inContext: context ].
	targetObject := self modelOf: call.
	self assert: targetObject class equals: GtLRefactoringResult.
	self assert: targetObject status equals: 'failed'.
	self assert: targetObject hasFailed.
	self assert: targetObject undoChange isNil.
	self assert: targetObject codeChangeResults isEmpty.
	self assert: targetObject errorMessage notEmpty.
	self assert: (objectStorage objectAt: objectId) isApplied.
	self
		assert: (objectStorage objectAt: objectId) applicationStatus
		equals: 'failed'.
	secondCall := self
			executeTool: GtLToolForApplyRefactoring new
			withArguments: (self argumentsWithObjectId: objectId)
			inContext: context.
	self
		assertProblem: (self modelOf: secondCall)
		withErrorMessage: objectId , ' was already applied and failed (result ' , targetObject objectId
				, '): the changes made before the error stay in the image. To retry, preview the refactoring again; the new preview starts from the code as it is now'.
	^ call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyFailingPreviewResponse [
	"When applying fails partway, the response says so with the error and lists the changes made before it, also when the changes were not wanted. The stored result tells the same, and the preview is not applied again"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| anOtherEnvironment anOtherClass aNamespace storage preview arguments call json again |
			anOtherEnvironment := GtPharoDummiesGenerator
					withPackages: 1
					classHierarchy: 1.
			[ anOtherClass := anOtherEnvironment anyDummyLeafClass realClass.
			aNamespace := GtRBNamespace new.
			(aNamespace classFor: aLeafClass)
				compile: 'appliedBeforeError ^ 1'
				classified: #examples.
			(aNamespace classFor: anOtherClass)
				compile: 'failingMethod ^ 2'
				classified: #examples ] ensure: [ self removeDummies: anOtherEnvironment ].
			storage := GtLObjectStorage new.
			preview := GtLRefactoringPreview namespace: aNamespace.
			preview
				objectId: (storage
						addNewObject: preview
						reason: (GtLStoredObjectStringReason text: 'Refactoring preview')).
			arguments := self argumentsWithObjectId: preview objectId.
			arguments at: 'displayOptions' put: {'includeChanges' -> false} asDictionary.
			call := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: arguments
					inContext: (GtLToolExecutionContext new objectStorage: storage).
			json := self jsonOf: call.
			self assert: (json at: 'status') equals: 'failed'.
			self assert: (json at: 'errorMessage') notEmpty.
			self
				assert: ((json at: 'codeChanges') collect: [ :each | each at: 'target' ]) asArray
				equals: {aLeafClass name , '>>#appliedBeforeError'}.
			self
				assert: (storage objectAt: (json at: 'objectId')) status
				equals: 'failed'.
			again := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: preview objectId)
					inContext: (GtLToolExecutionContext new objectStorage: storage).
			self
				assert: ((self modelOf: again) errorMessage
						includesSubstring: 'was already applied and failed').
			again := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: (json at: 'objectId'))
					inContext: (GtLToolExecutionContext new objectStorage: storage).
			self
				assert: ((self modelOf: again) errorMessage
						includesSubstring: 'is the result of an applied refactoring, not a preview').
			json ]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyNonRefactoringObject [
	<gtExample>
	| objectStorage objectId call |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 42 reasonString: 'example object'.
	call := self
			executeTool: GtLToolForApplyRefactoring new
			withArguments: (self argumentsWithObjectId: objectId)
			inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: objectId , ' is not a refactoring preview'.
	^ call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyPushUpMethodResponse [
	"What an agent gets when it applies a preview with a changes list: the status, the refactoring, the objectId of the stored result and each change made in the image, with its kind and target. The result keeps the same changes"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| storage objectId call json result |
			aLeafClass compile: 'pushedUpMethod ^ 42' classified: #examples.
			storage := GtLObjectStorage new.
			objectId := self
					previewTransformation: (Dictionary new
							at: 'PushUpMethod'
								put: (Dictionary new
										at: 'methodClassName' put: aLeafClass name asString;
										at: 'methodNameToPushUp' put: 'pushedUpMethod';
										at: 'targetClassName' put: aRootClass name asString;
										yourself);
							yourself)
					in: storage.
			call := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: objectId)
					inContext: (GtLToolExecutionContext new objectStorage: storage).
			json := self jsonOf: call.
			self
				assert: json keys asSet
				equals: #('status' 'refactoringName' 'refactoringDescription' 'changesCount' 'objectId' 'codeChanges')
						asSet.
			self assert: (json at: 'status') equals: 'applied'.
			result := storage objectAt: (json at: 'objectId').
			self assert: result == (self modelOf: call).
			self assert: result preview == (storage objectAt: objectId).
			self
				assert: ((json at: 'codeChanges')
						collect: [ :each | (each at: 'kind') -> (each at: 'target') ]) asArray
				equals: {'added method' -> (aRootClass name , '>>#pushedUpMethod').
						'removed method' -> (aLeafClass name , '>>#pushedUpMethod')}.
			self assert: result codeChangeResults size equals: 2.
			json ]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyTwice [
	"An applied preview is not applied again: the refusal names its result, whose changes are in the image"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| objectStorage objectId context first call |
			objectStorage := GtLObjectStorage new.
			objectId := self previewAddMethodTo: aLeafClass in: objectStorage.
			context := GtLToolExecutionContext new objectStorage: objectStorage.
			first := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: objectId)
					inContext: context.
			call := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: objectId)
					inContext: context.
			self
				assertProblem: (self modelOf: call)
				withErrorMessage: objectId , ' was already applied (result ' , (self modelOf: first) objectId
						, '): its changes are in the image'.
			call ]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyWithEmptyObjectId [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForApplyRefactoring new
			withArguments: (self argumentsWithObjectId: '   ')
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertMissingArgument: (self modelOf: call)
		withArgumentName: 'objectId'
		errorMessage: 'Missing argument called objectId'.
	^ call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyWithInvalidDisplayOption [
	"The JSON schema refuses a negative limit before the tool runs"

	<gtExample>
	| call arguments |
	arguments := self argumentsWithObjectId: 'abc123'.
	arguments at: 'displayOptions' put: {'methodsLimit' -> -1} asDictionary.
	call := self
			executeTool: GtLToolForApplyRefactoring new
			withArguments: arguments
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assert: (self modelOf: call) class
		equals: GtLJSONSchemaValidationErrorDomainObject.
	self
		assert: (self modelOf: call) errorMessage
		equals: '@[displayOptions/methodsLimit] smaller than minimum [0]'.
	^ call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyWithMissingObjectId [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForApplyRefactoring new
			withArguments: Dictionary new
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertMissingRequiredProperties: (self modelOf: call)
		withPropertyNames: #('objectId')
		path: #(nil)
		errorMessage: 'required properties missing [objectId]'.
	^ call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyWithUnknownObjectId [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForApplyRefactoring new
			withArguments: (self argumentsWithObjectId: 'missing-object-id')
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertMissingObject: (self modelOf: call)
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^ call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyWithoutObjectStorage [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForApplyRefactoring new
			withArguments: (self argumentsWithObjectId: 'missing-object-id').
	self
		assertMissingInformation: (self modelOf: call)
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> argumentsWithObjectId: aString [
	^(Dictionary new)
		at: 'objectId' put: aString;
		yourself
]

{ #category : #support }
GtLToolForApplyRefactoringExamples >> executeTool: aTool withArguments: aDictionary inContext: aContext [
	"Applying changes the image: keep the changes out of the global undo/redo history"

	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ super
				executeTool: aTool
				withArguments: aDictionary
				inContext: aContext ]
]

{ #category : #private }
GtLToolForApplyRefactoringExamples >> previewAddMethodTo: aClass in: anObjectStorage [
	^ self
		previewTransformation: (self addMethodTransformationTo: aClass name asString)
		in: anObjectStorage
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> previewTransformation: aTransformation in: anObjectStorage [
	| call |
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (Dictionary new
					at: 'transformations' put: (Array with: aTransformation);
					yourself)
			inContext: (GtLToolExecutionContext new objectStorage: anObjectStorage).
	^ (self modelOf: call) objectId
]
