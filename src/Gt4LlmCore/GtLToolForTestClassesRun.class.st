Class {
	#name : #GtLToolForTestClassesRun,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLToolForTestClassesRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSUnitClassesRun: self
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRun >> description [
	^ 'Execute SUnit test classes and report the aggregated results. The argument `classNames` is mandatory and it must not be empty.

Examples:
- Run one class:
    {"classNames": "SomeTestCase"}
- Run multiple classes:
    {"classNames": "SomeTestCase AnotherTestCase"}'
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRun >> detailForTest: aTest inResult: aResult [
	^ GtLTestCaseDomainObject new
		testCase: aTest;
		result: aResult
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRun >> name [
	^ 'testsInClassesRun'
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRun >> normalizedClassNamesFrom: rawValue [
	| items result |
	rawValue ifNil: [ ^ #() ].
	items := (rawValue isString or: [ rawValue isSymbol ])
		ifTrue: [ { rawValue } ]
		ifFalse: [ rawValue isCollection
			ifTrue: [ rawValue asArray ]
			ifFalse: [ { rawValue } ] ].
	result := OrderedCollection new.
	items do: [ :each |
		each ifNotNil: [
			(each asString findTokens: Character space)
				do: [ :token | | trimmed |
					trimmed := token withBlanksTrimmed.
					trimmed isEmpty ifFalse: [ result add: trimmed ] ] ] ].
	^ result asArray
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRun >> parametersDescription [
	^ #('classNames')
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRun >> privatePerformToolCall: aToolCall [
	| arguments rawClassNames classNames details notFound notTestCase |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	rawClassNames := arguments
			at: 'classNames'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'classNames' ].
	classNames := rawClassNames findTokens: String space.
	classNames isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'classNames' ].
	details := OrderedCollection new.
	notFound := OrderedCollection new.
	notTestCase := OrderedCollection new.
	classNames
		do: [ :className | 
			Smalltalk globals
				at: className asSymbol
				ifPresent: [ :class | 
					(class isTestCase)
						ifFalse: [ notTestCase add: class ]
						ifTrue: [ | result |
							result := class suite run.
							result tests
								do: [ :test | details add: (self detailForTest: test inResult: result) ] ] ]
				ifAbsent: [ notFound add: className ] ].

	^ GtLTestCasesDomainObject new
		testCases: details asArray;
		notFoundClassNames: notFound asArray;
		notTestCaseClasses: notTestCase asArray
]
