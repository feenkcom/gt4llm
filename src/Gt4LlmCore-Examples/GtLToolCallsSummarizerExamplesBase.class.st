"
Common superclass for summarizer examples, providing utility methods for constructing and executing tool calls used in examples.
"
Class {
	#name : #GtLToolCallsSummarizerExamplesBase,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Summarizers'
}

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

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> removeSelector: aSelector fromClass: aClass [
	(aClass includesSelector: aSelector) ifTrue: [ aClass removeSelector: aSelector ]
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> toolCallNamed: aName arguments: aDictionary [
	^ GtLFunctionToolCall new
		name: aName;
		arguments: aDictionary;
		yourself
]

{ #category : #utilities }
GtLToolCallsSummarizerExamplesBase >> toolMessageFrom: aToolCall [
	^ GtLToolMessage new
		toolCall: aToolCall;
		output: aToolCall result;
		yourself
]
