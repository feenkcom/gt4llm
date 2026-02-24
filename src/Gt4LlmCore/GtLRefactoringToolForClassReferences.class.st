Class {
	#name : #GtLRefactoringToolForClassReferences,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> name [
	^ 'rbClassReferences'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> parametersDescription [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> privatePerformToolCall: aToolCall [
	| arguments className targetClass references |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				receiverName: self name;
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'className' ].
	targetClass := self model classNamed: className.
	targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
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
