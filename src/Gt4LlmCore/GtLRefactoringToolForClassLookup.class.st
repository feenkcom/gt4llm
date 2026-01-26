Class {
	#name : #GtLRefactoringToolForClassLookup,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLRefactoringToolForClassLookup class >> leJsonV4Name [
	^ #gtLRefactoringToolForClassLookup
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> name [
	^ 'rbLookupClass'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassLookup >> privatePerformToolCall: aToolCall [
	| arguments className targetClass |
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
	^ GtLRefactoringClassDomainObject new
		model: self model;
		targetClass: targetClass
]
