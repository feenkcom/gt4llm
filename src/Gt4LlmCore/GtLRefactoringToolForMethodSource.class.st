Class {
	#name : #GtLRefactoringToolForMethodSource,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> description [
	^ 'Gets a method by name and returns its source code. The third argument (classSide) should be true if the method is on the class side. It should be false if the method if on the instance side.'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> name [
	^ 'rbMethodSource'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> parametersDescription [
	^ #('className' 'methodName' 'classSide')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> privatePerformToolCall: aToolCall [
	| arguments className methodName classSideFlag targetClass searchClass method |
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
	methodName := arguments
			at: 'methodName'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'methodName' ].
	targetClass := self model classNamed: className.
	targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
	classSideFlag := arguments at: 'classSide' ifAbsent: [ false ].
	searchClass := (#('' true '' true) includes: classSideFlag)
			ifTrue: [ targetClass classSide ]
			ifFalse: [ targetClass ].
	method := searchClass methodFor: methodName asSymbol.
	method
		ifNil: [ ^ GtLMissingDomainObject new
				objectName: (String
						streamContents: [ :aStream | 
							aStream
								nextPutAll: searchClass name asString;
								nextPutAll: '>>#';
								nextPutAll: methodName asString ]) ].
	^ GtLRefactoringMethodSourceCodeDomainObject new
		model: self model;
		method: method
]
