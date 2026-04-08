"
Magritte-based tool for retrieving class references in a GtRBNamespace model.
"
Class {
	#name : #GtLRefactoringToolForClassReferences,
	#superclass : #GtLAbstractRefactoringMagritteTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #accessing }
GtLRefactoringToolForClassReferences >> isUsingDataViews [
	^ true
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> name [
	^ 'rbClassReferences'
]

{ #category : #executing }
GtLRefactoringToolForClassReferences >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments targetClassName targetClass references |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	targetClassName := arguments at: 'targetClassName'.
	targetClass := self model classNamed: targetClassName.
	targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: targetClassName ].
	references := Array
		streamContents: [ :stream | 
			self model
				allReferencesToClass: targetClass
				do: [ :each | stream << each ] ].
	
	^ GtLRefactoringClassReferencesDomainObject new 
		model: self model;
		targetClass: targetClass;
		references: references.
]

{ #category : #magritte }
GtLRefactoringToolForClassReferences >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target class name';
		accessor: #targetClassName;
		beRequired
]
