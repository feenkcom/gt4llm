Class {
	#name : #GtLToolForApplyRefactoringExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> addClassTransformation [
	^(Dictionary new)
		at: 'AddClass'
			put: ((Dictionary new)
					at: 'newClassName' put: 'GtLAppliedExampleClass';
					at: 'superclassName' put: 'Object';
					at: 'packageName' put: 'Gt4LlmCore-Examples';
					at: 'slotNames' put: 'first second';
					at: 'tagName' put: '';
					yourself);
		yourself
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> addMethodTransformation [
	^self addMethodTransformationTo: 'GtLToolForApplyRefactoringExamples'
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
	<gtExample>
	| objectStorage objectId |
	self removeAppliedClass.
	objectStorage := GtLObjectStorage new.
	objectId := self previewTransformation: self addClassTransformation
				in: objectStorage.
	
	[| call targetObject newClass |
	call := self
				executeTool: GtLToolForApplyRefactoring new
				withArguments: (self argumentsWithObjectId: objectId)
				inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLAppliedRefactoring.
	self assert: targetObject status equals: 'applied'.
	self assert: targetObject changesCount equals: 1.
	self assert: targetObject preview == (objectStorage objectAt: objectId).
	self assert: targetObject preview isApplied.
	newClass := Smalltalk globals classNamed: #GtLAppliedExampleClass.
	self assert: newClass notNil.
	self assert: newClass superclass equals: Object.
	self assert: newClass instVarNames asArray equals: #(#first #second).
	self assert: newClass package name equals: 'Gt4LlmCore-Examples'.
	^call]
			ensure: [self removeAppliedClass]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyAddMethod [
	<gtExample>
	| objectStorage objectId |
	self removeAppliedMethod.
	objectStorage := GtLObjectStorage new.
	objectId := self previewAddMethodIn: objectStorage.
	
	[| call targetObject |
	call := self
				executeTool: GtLToolForApplyRefactoring new
				withArguments: (self argumentsWithObjectId: objectId)
				inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLAppliedRefactoring.
	self assert: targetObject status equals: 'applied'.
	self assert: targetObject changesCount equals: 1.
	self assert: targetObject preview == (objectStorage objectAt: objectId).
	self assert: targetObject preview isApplied.
	self assert: (self class includesSelector: #appliedRefactoringMethod).
	self assert: (self class >> #appliedRefactoringMethod) sourceCode
		equals: 'appliedRefactoringMethod ^ 42'.
	^call]
			ensure: [self removeAppliedMethod]
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyAfterClassRemoval [
	"Applying fails when the class of a previewed method was removed in the meantime.
	The applied refactoring is then marked as failed and holds the frozen exception."

	<gtExample>
	| environment objectStorage objectId call targetObject |
	environment := GtPharoDummyEnvironment withPackages: 1 classes: 1.
	objectStorage := GtLObjectStorage new.

	[ objectId := self
			previewTransformation: (self addMethodTransformationTo: environment anyDummyClass className asString)
			in: objectStorage ] ensure: [ environment removeFromSystem ].
	call := GtRefactoryChangeManager
			isolatedInstanceDuring: [ self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (self argumentsWithObjectId: objectId)
					inContext: (GtLToolExecutionContext new objectStorage: objectStorage) ].
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLAppliedRefactoring.
	self assert: targetObject status equals: 'failed'.
	self assert: targetObject hasFailed.
	self assert: targetObject undoChange isNil.
	self assert: targetObject codeChangeResults isEmpty.
	self
		assertExceptionDomainObject: targetObject exception
		withExceptionClass: MessageNotUnderstood
		messageSubstring: '#includesSelector: was sent to nil'.
	self
		assert: (targetObject errorMessage
				includesSubstring: '#includesSelector: was sent to nil').
	self assert: (objectStorage objectAt: objectId) isApplied not.
	^ call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyNonRefactoringObject [
	<gtExample>
	| objectStorage objectId call |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 42 reason: 'example object'.
	call := self
				executeTool: GtLToolForApplyRefactoring new
				withArguments: (self argumentsWithObjectId: objectId)
				inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assertProblem: call result targetObject
		withErrorMessage: objectId , ' is not a refactoring preview'.
	^call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyTwice [
	<gtExample>
	| objectStorage objectId context |
	self removeAppliedMethod.
	objectStorage := GtLObjectStorage new.
	objectId := self previewAddMethodIn: objectStorage.
	context := GtLToolExecutionContext new objectStorage: objectStorage.
	
	[| call |
	self
		executeTool: GtLToolForApplyRefactoring new
		withArguments: (self argumentsWithObjectId: objectId)
		inContext: context.
	call := self
				executeTool: GtLToolForApplyRefactoring new
				withArguments: (self argumentsWithObjectId: objectId)
				inContext: context.
	self assertProblem: call result targetObject
		withErrorMessage: objectId , ' was already applied'.
	^call]
			ensure: [self removeAppliedMethod]
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
		assertMissingArgument: call result targetObject
		withArgumentName: 'objectId'
		errorMessage: 'Missing argument called objectId'.
	^call
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
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('objectId')
		path: #(nil)
		errorMessage: 'required properties missing [objectId]'.
	^call
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
		assertMissingObject: call result targetObject
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^call
]

{ #category : #examples }
GtLToolForApplyRefactoringExamples >> applyWithoutObjectStorage [
	<gtExample>
	| call |
	call := self executeTool: GtLToolForApplyRefactoring new
				withArguments: (self argumentsWithObjectId: 'missing-object-id').
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^call
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> argumentsWithObjectId: aString [
	^(Dictionary new)
		at: 'objectId' put: aString;
		yourself
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> previewAddMethodIn: anObjectStorage [
	^self previewTransformation: self addMethodTransformation
		in: anObjectStorage
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> previewTransformation: aTransformation in: anObjectStorage [
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: ((Dictionary new)
						at: 'transformations' put: (Array with: aTransformation);
						yourself)
				inContext: (GtLToolExecutionContext new objectStorage: anObjectStorage).
	^call result targetObject objectId
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> removeAppliedClass [
	(Smalltalk globals classNamed: #GtLAppliedExampleClass)
		ifNotNil: [:aClass | aClass removeFromSystem]
]

{ #category : #helpers }
GtLToolForApplyRefactoringExamples >> removeAppliedMethod [
	(self class includesSelector: #appliedRefactoringMethod)
		ifTrue: [self class removeSelector: #appliedRefactoringMethod]
]
