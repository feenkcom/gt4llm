Class {
	#name : #GtLToolForPreviewRefactoringExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #helpers }
GtLToolForPreviewRefactoringExamples >> addClassTransformation [
	^(Dictionary new)
		at: 'AddClass'
			put: ((Dictionary new)
					at: 'newClassName' put: 'GtLPreviewedExampleClass';
					at: 'superclassName' put: 'Object';
					at: 'packageName' put: 'Gt4LlmCore-Examples';
					at: 'slotNames' put: 'first second';
					at: 'tagName' put: '';
					yourself);
		yourself
]

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
GtLToolForPreviewRefactoringExamples >> previewAddClass [
	"The new source of an added class is its fluid definition, as the applied refactoring reports it"

	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array with: self addClassTransformation))
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	targetObject := self modelOf: call.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes size equals: 1.
	self
		assert: targetObject changes first changeDescription
		equals: 'Define GtLPreviewedExampleClass'.
	self
		assert: targetObject changes first newSource
		equals: 'Object << #GtLPreviewedExampleClass' , String cr , String tab
				, 'slots: { #first . #second };' , String cr , String tab
				, 'package: ''Gt4LlmCore-Examples'''.
	self assert: (Smalltalk globals includesKey: #GtLPreviewedExampleClass) not.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewAddClassWithMethod [
	<gtExample>
	| methodTransformation call targetObject |
	methodTransformation := Dictionary new
			at: 'AddMethod'
				put: (Dictionary new
						at: 'methodClassName' put: 'GtLPreviewedExampleClass';
						at: 'protocolName' put: 'accessing';
						at: 'sourceCodeOfMethodToAdd' put: 'first ^ first';
						yourself);
			yourself.
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array with: self addClassTransformation with: methodTransformation))
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	targetObject := self modelOf: call.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self
		assert: (targetObject changes collect: [ :each | each changeDescription ]) asArray
		equals: #('Define GtLPreviewedExampleClass' 'Add GtLPreviewedExampleClass>>#first').
	self assert: targetObject changesCount equals: 2.
	self assert: targetObject changes last newSource equals: 'first ^ first'.
	self assert: (Smalltalk globals includesKey: #GtLPreviewedExampleClass) not.
	^ call
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
	targetObject := self modelOf: call.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes size equals: 1.
	self
		assert: targetObject changes first changeDescription
		equals: 'Add GtLToolForPreviewRefactoringExamples>>#previewedMethod'.
	self
		assert: targetObject changes first newSource
		equals: 'previewedMethod ^ 42'.
	self assert: targetObject isApplied not.
	self assert: (objectStorage objectAt: targetObject objectId) == targetObject.
	self assert: (self class includesSelector: #previewedMethod) not.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewOverrideOfTraitProvidedMethod [
	"A method that a class only gets from a trait is added to the class, not modified"

	<gtExample>
	| call preview |
	call := self
			previewTransformations: {Dictionary new
						at: 'AddMethod'
							put: (Dictionary new
									at: 'methodClassName' put: GtLExampleTraitUser name asString;
									at: 'protocolName' put: 'examples';
									at: 'sourceCodeOfMethodToAdd' put: 'traitMethod ^ 7';
									yourself);
						yourself}.
	preview := self modelOf: call.
	self assert: preview class equals: GtLRefactoringPreview.
	self assert: preview changes size equals: 1.
	self assert: preview changes first kind equals: 'added method'.
	self assert: preview isApplied not.
	self assert: (GtLExampleTraitUser includesLocalSelector: #traitMethod) not.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewPushUpMethod [
	<gtExample>
	| objectStorage call targetObject |
	objectStorage := GtLObjectStorage new.
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array
							with: (self
									pushUpMethod: 'argumentsWithTransformations:'
									from: 'GtLToolForPreviewRefactoringExamples'
									to: 'GtLAbstractMagritteFunctionToolExamples')))
			inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := self modelOf: call.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes notEmpty.
	self assert: targetObject isApplied not.
	self assert: (objectStorage objectAt: targetObject objectId) == targetObject.
	self
		assert: (GtLAbstractMagritteFunctionToolExamples
				includesSelector: #argumentsWithTransformations:) not.
	self assert: (self class includesSelector: #argumentsWithTransformations:).
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewPushUpOfTraitProvidedMethod [
	"A method that a class gets from a trait cannot be pushed up from that class"

	<gtExample>
	| call |
	call := self
			previewTransformations: {self
						pushUpMethod: 'traitMethod'
						from: GtLExampleTraitUser name asString
						to: 'Object'}.
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: GtLExampleTraitUser>>#traitMethod is not defined in its own class: it is provided by a trait. Its source is TGtLExampleTrait>>#traitMethod'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewRemovalOfInheritedMethod [
	"An inherited method is reported as a problem instead of failing the refactoring preconditions"

	<gtExample>
	| call definingReference |
	call := self
			previewTransformations: {self removeMethod: 'printString' from: 'GtLToolForPreviewRefactoringExamples'}.
	definingReference := GtLMethodReference
			fromCompiledMethod: (GtLToolForPreviewRefactoringExamples lookupSelector: #printString).
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: GtLToolForPreviewRefactoringExamples>>#printString is not defined in its own class: it is inherited. Its source is '
				, definingReference methodSignature.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewRemovalOfTraitMethod [
	"A method can be removed from the trait that defines it"

	<gtExample>
	| call preview |
	call := self
			previewTransformations: {self removeMethod: 'traitMethod' from: TGtLExampleTrait name asString}.
	preview := self modelOf: call.
	self assert: (preview isKindOf: GtLRefactoringPreview).
	self assert: preview isApplied not.
	self assert: (TGtLExampleTrait includesSelector: #traitMethod).
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewRemovalOfTraitProvidedMethod [
	<gtExample>
	| call |
	call := self
			previewTransformations: {self removeMethod: 'traitMethod' from: GtLExampleTraitUser name asString}.
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: GtLExampleTraitUser>>#traitMethod is not defined in its own class: it is provided by a trait. Its source is TGtLExampleTrait>>#traitMethod'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewRemovalWithoutClassName [
	"The class name is a required field of the transformation: the JSON schema refuses the transformation without it"

	<gtExample>
	| call |
	call := self
			previewTransformations: {Dictionary new
						at: 'RemoveMethod'
							put: (Dictionary new
									at: 'methodNameToRemove' put: 'printString';
									yourself);
						yourself}.
	self
		assertJSONSchemaValidationError: (self modelOf: call)
		withPath: #('transformations' 1)
		errorMessage: '@[transformations/1] anyOf expected'.
	^ call
]

{ #category : #helpers }
GtLToolForPreviewRefactoringExamples >> previewTransformations: aCollection [
	^ self
		executeTool: GtLToolForPreviewRefactoring new
		withArguments: (self argumentsWithTransformations: aCollection)
		inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new)
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
		assertMissingArgument: (self modelOf: call)
		withArgumentName: 'transformations'
		errorMessage: 'Missing argument called transformations'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithFailingRefactoring [
	<gtExample>
	| transformation call |
	transformation := self addMethodTransformation.
	(transformation at: 'AddMethod')
		at: 'sourceCodeOfMethodToAdd'
		put: 'previewedMethod ^ ^'.
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array with: transformation))
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertExceptionDomainObject: (self modelOf: call)
		withExceptionClass: RBRefactoringError
		messageSubstring: 'cannot be parsed'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithInvalidTransformations [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array with: self pushUpInstanceVariableOfUnknownClassTransformation))
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithMethodInUnknownClass [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array
							with: (self
									pushUpMethod: 'unknownSelector42'
									from: 'ClassThatDoesNotExist'
									to: 'GtLAbstractMagritteFunctionToolExamples')))
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithMethodNotImplemented [
	<gtExample>
	| call |
	call := self
			previewTransformations: {self
						pushUpMethod: 'unknownSelector42'
						from: 'GtLToolForPreviewRefactoringExamples'
						to: 'GtLAbstractMagritteFunctionToolExamples'}.
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: GtLToolForPreviewRefactoringExamples>>#unknownSelector42 is not found'.
	^ call
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
		assertMissingRequiredProperties: (self modelOf: call)
		withPropertyNames: #('transformations')
		path: #(nil)
		errorMessage: 'required properties missing [transformations]'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithPushUpMethodToUnknownClass [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array
							with: (self
									pushUpMethod: 'argumentsWithTransformations:'
									from: 'GtLToolForPreviewRefactoringExamples'
									to: 'ClassThatDoesNotExist')))
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithSeveralInvalidTransformations [
	<gtExample>
	| call |
	call := self
			previewTransformations: {self pushUpInstanceVariableOfUnknownClassTransformation.
					self
						pushUpMethod: 'unknownSelector42'
						from: 'GtLToolForPreviewRefactoringExamples'
						to: 'GtLAbstractMagritteFunctionToolExamples'}.
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Invalid transformations: Class not found: ClassThatDoesNotExist; GtLToolForPreviewRefactoringExamples>>#unknownSelector42 is not found'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithUnknownTransformation [
	<gtExample>
	| transformation call |
	transformation := Dictionary new
			at: 'RenameEverything' put: Dictionary new;
			yourself.
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self
					argumentsWithTransformations: (Array with: transformation))
			inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new).
	self
		assertJSONSchemaValidationError: (self modelOf: call)
		withPath: #('transformations' 1)
		errorMessage: '@[transformations/1] anyOf expected'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRefactoringExamples >> previewWithoutObjectStorage [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (self argumentsWithTransformations: (Array with: self addMethodTransformation)).
	self
		assertMissingInformation: (self modelOf: call)
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
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

{ #category : #helpers }
GtLToolForPreviewRefactoringExamples >> removeMethod: aSelectorString from: aClassName [
	^ Dictionary new
		at: 'RemoveMethod'
			put: (Dictionary new
					at: 'methodClassName' put: aClassName;
					at: 'methodNameToRemove' put: aSelectorString;
					yourself);
		yourself
]
