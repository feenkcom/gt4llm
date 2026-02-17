Class {
	#name : #GtLRefactoringToolForMethodReferences,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLRefactoringToolForMethodReferences class >> leJsonV4Name [
	^ #gtLRefactoringToolForMethodReferences
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> description [
	^ 'Search the image for the method referencing the given selector. There will be a maximum of 100 results.'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> name [
	^ 'rbMethodReferences'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> parametersDescription [
	^ #('selector')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> privatePerformToolCall: aToolCall [
	| arguments selector |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				receiverName: self name;
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	selector := arguments
			at: 'selector'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'selector' ].
	
	^ self sendersOf: selector
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> sendersOf: selectorString [
	| referencesStream count |
	referencesStream := WriteStream on: Array new.
	count := 0.
	self model
		allReferencesTo: selectorString asSymbol
		do: [ :eachReference | 
			referencesStream nextPut: eachReference.
			count := count + 1.
			count = 100
				ifTrue: [ ^ GtLRefactoringMethodReferencesDomainObject new
						model: self model;
						methodName: selectorString;
						references: referencesStream contents;
						mayHaveMore: true ] ].
	^ GtLRefactoringMethodReferencesDomainObject new
		model: self model;
		methodName: selectorString;
		references: referencesStream contents;
		mayHaveMore: false
]
