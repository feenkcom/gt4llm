"
Common superclass for summarizer examples, providing utility methods for constructing and executing tool calls used in examples.
"
Class {
	#name : #GtLToolCallsSummarizerExamplesBase,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> addClassTransformationNamed: aClassName superclass: aSuperclass slotNames: aString [
	"An AddClass transformation that adds the class to the package of aSuperclass"

	^ Dictionary new
		at: 'AddClass'
			put: (Dictionary new
					at: 'newClassName' put: aClassName asString;
					at: 'superclassName' put: aSuperclass name asString;
					at: 'packageName' put: aSuperclass package name asString;
					at: 'slotNames' put: aString;
					at: 'tagName' put: '';
					yourself);
		yourself
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> addMethodTransformationIn: aClass source: aSourceString [
	^ Dictionary new
		at: 'AddMethod'
			put: (Dictionary new
					at: 'methodClassName' put: aClass name asString;
					at: 'protocolName' put: 'examples';
					at: 'sourceCodeOfMethodToAdd' put: aSourceString;
					yourself);
		yourself
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> codeChangesSummarizerForToolCalls: aCollectionOfToolCalls [
	"Put the messages of aCollectionOfToolCalls in a messages group and return its code changes summarizer"

	| aGroup |
	aGroup := GtLMessagesGroup new.
	aCollectionOfToolCalls do: [ :each | aGroup add: (self toolMessageFrom: each) ].
	^ aGroup toolCallsSummarizers
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ]
]

{ #category : #private }
GtLToolCallsSummarizerExamplesBase >> fixedExecutionDetailsFrom: aStartDateAndTime to: anEndDateAndTime [
	| details |
	details := GtLFunctionToolCallExecutionDetails new.
	details
		startTime: aStartDateAndTime;
		endTime: anEndDateAndTime.
	^ details
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> performApplyRefactoringOf: aPreviewToolCall inContext: anExecutionContext [
	"Apply the refactoring previewed by aPreviewToolCall (a previewRefactoring or previewRewrite tool call)"

	^ self
		performApplyRefactoringWithObjectId: aPreviewToolCall result targetObject objectId
		inContext: anExecutionContext
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> performApplyRefactoringWithObjectId: anObjectId inContext: anExecutionContext [
	^ self
		performTool: GtLToolForApplyRefactoring new
		withArguments: (Dictionary new
				at: 'objectId' put: anObjectId;
				yourself)
		inContext: anExecutionContext
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> performClassCommentChangeFor: aClass to: aCommentString [
	^ self performTool: GtLMagritteToolForClassCommentChange new withArguments: (Dictionary new
		at: 'className' put: aClass name;
		at: 'classComment' put: aCommentString;
		yourself)
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> performClassCreationNamed: aClassName [
	^ self performTool: GtLMagritteToolForClassCreation new withArguments: (Dictionary new
		at: 'classCreationRequest' put: (Dictionary new
			at: 'targetClassName' put: aClassName;
			at: 'superclassName' put: 'Object';
			at: 'package' put: 'Gt4LlmCore-Examples';
			at: 'packageTag' put: 'Summarizers';
			at: 'instanceVariables' put: '';
			at: 'classVariables' put: '';
			at: 'classInstanceVariables' put: '';
			at: 'traitCompositionString' put: '';
			at: 'comment' put: 'temporary example class';
			yourself);
		yourself)
]

{ #category : #'tool execution' }
GtLToolCallsSummarizerExamplesBase >> performClassPackageChangeFor: aClassName toPackage: aPackageName [
	"Change the package of an existing class"
	^ self performTool: GtLMagritteToolForClassDefinitionChange new withArguments: (Dictionary new
		at: 'classChangeRequest' put: (Dictionary new
			at: 'targetClassName' put: aClassName;
			at: 'package' put: aPackageName;
			yourself);
		yourself)
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> performClassRemovalNamed: aClassName [
	^ self performTool: GtLMagritteToolForClassRemoval new withArguments: (Dictionary new
		at: 'className' put: aClassName;
		yourself)
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> performMethodCompilationFor: aClass selector: aSelector source: aSourceCode protocol: aProtocol [
	^ self performTool: GtLMagritteToolForMethodCompilation new withArguments: (Dictionary new
		at: 'methodRequest' put: (Dictionary new
			at: 'methodClassName' put: aClass name;
			at: 'sourceCode' put: aSourceCode;
			at: 'protocol' put: aProtocol;
			at: 'classSide' put: false;
			yourself);
		yourself)
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> performMethodRemovalFor: aClass selector: aSelector [
	^ self performTool: GtLMagritteToolForMethodRemoval new withArguments: (Dictionary new
		at: 'methodDescriptor' put: (Dictionary new
			at: 'methodClassName' put: aClass name;
			at: 'methodName' put: aSelector asString;
			at: 'classSide' put: false;
			yourself);
		yourself)
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> performPreviewRefactoring: aCollectionOfTransformations inContext: anExecutionContext [
	^ self
		performTool: GtLToolForPreviewRefactoring new
		withArguments: (Dictionary new
				at: 'transformations' put: aCollectionOfTransformations asArray;
				yourself)
		inContext: anExecutionContext
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> performPreviewRewriteFrom: aFromPattern to: aToPattern inClass: aClass inContext: anExecutionContext [
	^ self
		performTool: GtLToolForPreviewRewrite new
		withArguments: (Dictionary new
				at: 'from' put: aFromPattern;
				at: 'to' put: aToPattern;
				at: 'isMethodPattern' put: false;
				at: 'className' put: aClass name asString;
				at: 'packageName' put: '';
				yourself)
		inContext: anExecutionContext
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> performTool: aTool withArguments: aDictionary [
	| toolCall |
	toolCall := GtLFunctionToolCall new
		name: aTool name;
		rawArguments: aDictionary;
		yourself.
	aTool performToolCall: toolCall inContext: nil.
	^ toolCall
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> performTool: aTool withArguments: aDictionary inContext: anExecutionContext [
	| toolCall |
	toolCall := GtLFunctionToolCall new
			name: aTool name;
			rawArguments: aDictionary;
			yourself.
	aTool performToolCall: toolCall inContext: anExecutionContext.
	^ toolCall
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> pushUpInstanceVariableTransformationOf: aVariableName to: aSuperclass [
	"A PushUpInstanceVariable transformation that pushes the variable up from the subclasses of aSuperclass"

	^ Dictionary new
		at: 'PushUpInstanceVariable'
			put: (Dictionary new
					at: 'variableClassName' put: aSuperclass name asString;
					at: 'variableNameToPushUp' put: aVariableName asString;
					yourself);
		yourself
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> pushUpMethodTransformationOf: aSelector from: aClass to: aSuperclass [
	^ Dictionary new
		at: 'PushUpMethod'
			put: (Dictionary new
					at: 'methodClassName' put: aClass name asString;
					at: 'methodNameToPushUp' put: aSelector asString;
					at: 'targetClassName' put: aSuperclass name asString;
					yourself);
		yourself
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> removeMethodTransformationOf: aSelector in: aClass [
	^ Dictionary new
		at: 'RemoveMethod'
			put: (Dictionary new
					at: 'methodClassName' put: aClass name asString;
					at: 'methodNameToRemove' put: aSelector asString;
					yourself);
		yourself
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> removeSelector: aSelector fromClass: aClass [
	(aClass includesSelector: aSelector) ifTrue: [ aClass removeSelector: aSelector ]
]

{ #category : #private }
GtLToolCallsSummarizerExamplesBase >> toolCallNamed: aName arguments: aDictionary [
	^ GtLFunctionToolCall new
		name: aName;
		arguments: aDictionary;
		yourself
]

{ #category : #private }
GtLToolCallsSummarizerExamplesBase >> toolCallNamed: aName arguments: aDictionary executionDetails: anExecutionDetails [
	^ (self toolCallNamed: aName arguments: aDictionary)
		executionDetails: anExecutionDetails;
		yourself
]

{ #category : #private }
GtLToolCallsSummarizerExamplesBase >> toolMessageFrom: aToolCall [
	^ GtLToolMessage new
		toolCall: aToolCall;
		output: aToolCall result;
		yourself
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> withDummyHierarchyDo: aBlock [
	"Evaluate aBlock with the root and the leaf class of a temporary hierarchy of two classes,
	in an isolated change manager, and remove the temporary classes afterwards"

	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ | anEnvironment aLeafClass |
			anEnvironment := GtPharoDummiesGenerator withPackages: 1 classHierarchy: 2.
			[ aLeafClass := anEnvironment anyDummyLeafClass realClass.
			aBlock value: aLeafClass superclass value: aLeafClass ]
				ensure: [ anEnvironment removeFromSystem ] ]
]

{ #category : #'utilities - refactorings' }
GtLToolCallsSummarizerExamplesBase >> withRefactoringContextDo: aBlock [
	"Evaluate aBlock with the root and the leaf class of a temporary hierarchy (see #withDummyHierarchyDo:)
	and with a tool execution context whose object storage keeps the refactoring previews,
	so that previews and applies of refactorings can be performed as tool calls"

	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			aBlock
				value: aRootClass
				value: aLeafClass
				value: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new) ]
]
