"
Magritte-based tool for looking up class details in a GtRBNamespace model.
"
Class {
	#name : #GtLRefactoringToolForClassLookup,
	#superclass : #GtLAbstractRefactoringMagritteTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.'
]

{ #category : #accessing }
GtLRefactoringToolForClassLookup >> isUsingDataViews [
	^ true
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> name [
	^ 'rbLookupClass'
]

{ #category : #executing }
GtLRefactoringToolForClassLookup >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments targetClassName targetClass |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	targetClassName := arguments at: 'targetClassName'.
	targetClass := self model classNamed: targetClassName.
	targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: targetClassName ].
	^ GtLRefactoringClassDomainObject new
		model: self model;
		targetClass: targetClass
]

{ #category : #magritte }
GtLRefactoringToolForClassLookup >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target class name';
		accessor: #targetClassName;
		beRequired
]
