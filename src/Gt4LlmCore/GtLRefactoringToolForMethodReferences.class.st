"
Magritte-based tool for finding method references (senders) in a GtRBNamespace model.
"
Class {
	#name : #GtLRefactoringToolForMethodReferences,
	#superclass : #GtLAbstractRefactoringMagritteTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> description [
	^ 'Search the image for the method referencing the given selector. There will be a maximum of 100 results.'
]

{ #category : #accessing }
GtLRefactoringToolForMethodReferences >> isUsingDataViews [
	^ true
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> name [
	^ 'rbMethodReferences'
]

{ #category : #executing }
GtLRefactoringToolForMethodReferences >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments selector |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	selector := arguments at: 'selector'.
	
	^ self sendersOf: selector
]

{ #category : #magritte }
GtLRefactoringToolForMethodReferences >> selectorDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Selector';
		accessor: #selector;
		beRequired
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
