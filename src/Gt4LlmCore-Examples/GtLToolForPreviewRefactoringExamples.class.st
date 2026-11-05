Class {
	#name : #GtLToolForPreviewRefactoringExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #helpers }
GtLToolForPreviewRefactoringExamples >> addMethodTransformation [
	^(Dictionary new)
		at: 'AddMethod'
			put: ((Dictionary new)
					at: 'methodClassName' put: 'GtLToolForPreviewRefactoringExamples';
					at: 'protocolName' put: 'examples';
					at: 'sourceCodeOfMethodToAdd' put: 'previewedMethod ^ 42';
					yourself);
		yourself
]

{ #category : #helpers }
GtLToolForPreviewRefactoringExamples >> argumentsWithTransformations: aCollection [
	^(Dictionary new)
		at: 'transformations' put: aCollection asArray;
		yourself
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewAddMethod [
	<gtExample>
	| objectStorage call targetObject |
	objectStorage := GtLObjectStorage new.
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: self addMethodTransformation))
				inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes size equals: 1.
	self assert: targetObject changes first changeDescription
		equals: 'GtLToolForPreviewRefactoringExamples>>previewedMethod'.
	self assert: targetObject changes first newSource
		equals: 'previewedMethod ^ 42'.
	self assert: targetObject isApplied not.
	self
		assert: (objectStorage objectAt: targetObject objectId) == targetObject.
	self assert: (self class includesSelector: #previewedMethod) not.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewPushUpMethod [
	<gtExample>
	| objectStorage call targetObject |
	objectStorage := GtLObjectStorage new.
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: (self
										pushUpMethod: 'argumentsWithTransformations:'
										from: 'GtLToolForPreviewRefactoringExamples'
										to: 'GtLAbstractMagritteFunctionToolExamples')))
				inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes notEmpty.
	self assert: targetObject isApplied not.
	self
		assert: (objectStorage objectAt: targetObject objectId) == targetObject.
	self
		assert: (GtLAbstractMagritteFunctionToolExamples
				includesSelector: #argumentsWithTransformations:) not.
	self assert: (self class includesSelector: #argumentsWithTransformations:).
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithEmptyTransformations [
	<gtExample>
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self argumentsWithTransformations: #())
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'transformations'
		errorMessage: 'Missing argument called transformations'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithFailingRefactoring [
	<gtExample>
	| transformation call |
	transformation := self addMethodTransformation.
	(transformation at: 'AddMethod') at: 'sourceCodeOfMethodToAdd'
		put: 'previewedMethod ^ ^'.
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: transformation))
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertExceptionDomainObject: call result targetObject
		withExceptionClass: RBRefactoringError
		messageSubstring: 'cannot be parsed'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithInvalidTransformations [
	<gtExample>
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self argumentsWithTransformations: (Array
								with: self pushUpInstanceVariableOfUnknownClassTransformation))
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self assertProblem: call result targetObject
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithMethodInUnknownClass [
	<gtExample>
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: (self
										pushUpMethod: 'unknownSelector42'
										from: 'ClassThatDoesNotExist'
										to: 'GtLAbstractMagritteFunctionToolExamples')))
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self assertProblem: call result targetObject
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithMethodNotImplemented [
	<gtExample>
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: (self
										pushUpMethod: 'unknownSelector42'
										from: 'GtLToolForPreviewRefactoringExamples'
										to: 'GtLAbstractMagritteFunctionToolExamples')))
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self assertProblem: call result targetObject
		withErrorMessage: 'Invalid transformations: GtLToolForPreviewRefactoringExamples does not implement #unknownSelector42'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithMissingTransformations [
	<gtExample>
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: Dictionary new
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('transformations')
		path: #(nil)
		errorMessage: 'required properties missing [transformations]'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithPushUpMethodToUnknownClass [
	<gtExample>
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: (self
										pushUpMethod: 'argumentsWithTransformations:'
										from: 'GtLToolForPreviewRefactoringExamples'
										to: 'ClassThatDoesNotExist')))
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self assertProblem: call result targetObject
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithSeveralInvalidTransformations [
	<gtExample>
	| call |
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self argumentsWithTransformations: (Array
								with: self pushUpInstanceVariableOfUnknownClassTransformation
								with: (self
										pushUpMethod: 'unknownSelector42'
										from: 'GtLToolForPreviewRefactoringExamples'
										to: 'GtLAbstractMagritteFunctionToolExamples')))
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self assertProblem: call result targetObject
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist; GtLToolForPreviewRefactoringExamples does not implement #unknownSelector42'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithUnknownTransformation [
	<gtExample>
	| transformation call |
	transformation := (Dictionary new)
				at: 'RenameEverything' put: Dictionary new;
				yourself.
	call := self
				executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: transformation))
				inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('transformations' 1)
		errorMessage: '@[transformations/1] anyOf expected'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithoutObjectStorage [
	<gtExample>
	| call |
	call := self executeTool: GtLToolForPreviewRefactoring new
				withArguments: (self
						argumentsWithTransformations: (Array with: self addMethodTransformation)).
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^call
]

{ #category : #helpers }
GtLToolForPreviewRefactoringExamples >> pushUpInstanceVariableOfUnknownClassTransformation [
	^(Dictionary new)
		at: 'PushUpInstanceVariable'
			put: ((Dictionary new)
					at: 'variableClassName' put: 'ClassThatDoesNotExist';
					at: 'variableNameToPushUp' put: 'unknownVariable';
					yourself);
		yourself
]

{ #category : #helpers }
GtLToolForPreviewRefactoringExamples >> pushUpMethod: aSelectorString from: aClassName to: aTargetClassName [
	^(Dictionary new)
		at: 'PushUpMethod'
			put: ((Dictionary new)
					at: 'methodClassName' put: aClassName;
					at: 'methodNameToPushUp' put: aSelectorString;
					at: 'targetClassName' put: aTargetClassName;
					yourself);
		yourself
]
