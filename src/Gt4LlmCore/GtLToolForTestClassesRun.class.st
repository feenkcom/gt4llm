Class {
	#name : #GtLToolForTestClassesRun,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLToolForTestClassesRun >> classNamesDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Class names';
		accessor: #classNames;
		classes: { String };
		beRequired
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
GtLToolForTestClassesRun >> name [
	^ 'testsInClassesRun'
]

{ #category : #private }
GtLToolForTestClassesRun >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments classNames details notFound notTestCase |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	classNames := arguments at: 'classNames'.
	
	details := OrderedCollection new.
	notFound := OrderedCollection new.
	notTestCase := OrderedCollection new.
	
	classNames
		do: [ :className | 
			Smalltalk globals
				at: className asString asSymbol
				ifPresent: [ :class | 
					(class isTestCase)
						ifFalse: [ notTestCase add: class ]
						ifTrue: [ | results |
							results := class suite tests collect: [ :aTest | 
								aTest gtRunWithExplicitResult ].
							results do: [ :aTestWithResult | details add: 							
								(GtLTestCaseWithResultStatus new
									testCaseWithResult: aTestWithResult) ] ] ]
				ifAbsent: [ notFound add: className asString ] ].

	^ GtLTestCasesWithResultStatuses new
		testCases: details asArray;
		notFoundClassNames: notFound asArray;
		notTestCaseClasses: notTestCase asArray
]
