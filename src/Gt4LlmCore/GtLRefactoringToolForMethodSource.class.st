"
Magritte-based tool for retrieving method source code in a GtRBNamespace model. Takes a GtLMethodReference as parameter.
"
Class {
	#name : #GtLRefactoringToolForMethodSource,
	#superclass : #GtLAbstractRefactoringMagritteTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> description [
	^ 'Gets a method by name and returns its source code. The third argument (classSide) should be true if the method is on the class side. It should be false if the method if on the instance side.'
]

{ #category : #magritte }
GtLRefactoringToolForMethodSource >> methodReferenceDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
			accessor: #methodReference;
			classes: {GtLMethodReference};
			beRequired
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> name [
	^ 'rbMethodSource'
]

{ #category : #executing }
GtLRefactoringToolForMethodSource >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methodReference targetClassName methodName classSideFlag targetClass searchClass method |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodReference := arguments at: 'methodReference'.
	
	targetClassName := methodReference methodClassName.
	targetClassName ifNil: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'methodClassName' ].
	
	methodName := methodReference methodName.
	methodName ifNil: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'methodName' ].
	
	targetClass := self model classNamed: targetClassName.
	targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: targetClassName ].
	
	classSideFlag := methodReference isClassSide.
	searchClass := classSideFlag
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
