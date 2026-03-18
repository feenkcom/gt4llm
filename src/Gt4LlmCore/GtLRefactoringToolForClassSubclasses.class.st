Class {
	#name : #GtLRefactoringToolForClassSubclasses,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> name [
	^ 'rbClassSubclasses'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> parametersDescription [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments className targetClass subclasses |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'className' ].
	targetClass := self model classNamed: className.
	targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
	subclasses := targetClass subclasses.
	
	^ GtLRefactoringClassSubclassesDomainObject new 
		model: self model;
		targetClass: targetClass;
		subclasses: subclasses asArray
]
