"
Magritte-based tool for finding method implementors in a GtRBNamespace model.
"
Class {
	#name : #GtLRefactoringToolForMethodImplementors,
	#superclass : #GtLAbstractRefactoringMagritteTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #accessing }
GtLRefactoringToolForMethodImplementors >> isUsingDataViews [
	^ true
]

{ #category : #magritte }
GtLRefactoringToolForMethodImplementors >> methodNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> name [
	^ 'rbMethodImplementors'
]

{ #category : #executing }
GtLRefactoringToolForMethodImplementors >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methodName implementors |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodName := arguments at: 'methodName'.
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
