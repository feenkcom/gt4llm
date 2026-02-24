Class {
	#name : #GtLRefactoringToolForMethodImplementors,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'model'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> name [
	^ 'rbMethodImplementors'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> parametersDescription [
	^ #('methodName')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> privatePerformToolCall: aToolCall [
	| arguments methodName implementors |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				receiverName: self name;
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodName := arguments
			at: 'methodName'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'methodName' ].
	implementors := Array
			streamContents: [ :stream | 
				self model
					allImplementorsOf: methodName asSymbol
					do: [ :each | stream nextPut: each ] ].

	^ GtLRefactoringMethodImplementorsDomainObject new
		model: self model;
		methodName: methodName;
		implementors: implementors
]
