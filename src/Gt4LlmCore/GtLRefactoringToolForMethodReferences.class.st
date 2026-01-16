Class {
	#name : #GtLRefactoringToolForMethodReferences,
	#superclass : #GtLAbstractFunctionTool,
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
GtLRefactoringToolForMethodReferences >> parameters [
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
	| stream count |
	stream := WriteStream on: String new.
	count := 0.
	self model
		allReferencesTo: selectorString asSymbol
		do: [ :each | 
			stream << each modelClass name.
			each modelClass isMeta ifTrue: [ stream << ' class' ].
			stream << '>>#' << each selector << String cr.
			count := count + 1.
			count = 100
				ifTrue: [ ^ GtLRefactoringMethodReferencesDomainObject new
						model: self model;
						methodName: selectorString;
						references: stream contents;
						mayHaveMore: true ] ].
	^ GtLRefactoringMethodReferencesDomainObject new
		model: self model;
		methodName: selectorString;
		references: stream contents;
		mayHaveMore: false
]
