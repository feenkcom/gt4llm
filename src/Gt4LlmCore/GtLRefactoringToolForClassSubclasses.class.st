"
Magritte-based tool for retrieving subclasses of a class in a GtRBNamespace model.
"
Class {
	#name : #GtLRefactoringToolForClassSubclasses,
	#superclass : #GtLAbstractRefactoringMagritteTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #accessing }
GtLRefactoringToolForClassSubclasses >> isUsingDataViews [
	^ true
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> name [
	^ 'rbClassSubclasses'
]

{ #category : #executing }
GtLRefactoringToolForClassSubclasses >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments targetClassName targetClass subclasses |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	targetClassName := arguments at: 'targetClassName'.
	targetClass := self model classNamed: targetClassName.
	targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: targetClassName ].
	subclasses := targetClass subclasses.
	
	^ GtLRefactoringClassSubclassesDomainObject new 
		model: self model;
		targetClass: targetClass;
		subclasses: subclasses asArray
]

{ #category : #magritte }
GtLRefactoringToolForClassSubclasses >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target class name';
		accessor: #targetClassName;
		beRequired
]
