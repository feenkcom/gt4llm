Class {
	#name : #GtLToolForExampleClassesRun,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLToolForExampleClassesRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForExampleGroupRun: self
]

{ #category : #'llm-generated' }
GtLToolForExampleClassesRun >> description [
	^ 'Execute multiple gtExample methods gathered from one or more classes and report the aggregated results. The argument `classNames` is mandatory and it must be a non empty array of space separated strings holding class names.

Examples:
- To run just one class, provide an array with one value as the `classNames` value:
```
"classNames": "SomeClassWithExamples"
```

- running multiple classes:
```
"classNames": "SomeClassWithExamples SomeOtherClassWithExamples"]
```'
]

{ #category : #'as yet unclassified' }
GtLToolForExampleClassesRun >> extractExamplesFromClassesFrom: classNames in: examplesSet reportingNotFoundIn: notFound [
	classNames
		do: [ :className | 
			Smalltalk globals
				at: className asString asSymbol
				ifPresent: [ :class | 
					| factory |
					factory := GtExampleFactory new.
					factory sourceClass: class.
					factory gtExamplesContained do: [ :example | examplesSet add: example ] ]
				ifAbsent: [ notFound add: className asString ] ]
]

{ #category : #'as yet unclassified' }
GtLToolForExampleClassesRun >> extractExamplesFromMethodsFrom: arguments in: examplesSet reportingNotFoundIn: notFound [
	| methodSpecs |
	methodSpecs := (arguments at: 'methods' ifAbsent: [ #() ]) asArray.
	methodSpecs
		do: [ :spec | 
			| className methodName classSide class symbolName targetClass method example |
			(spec respondsTo: #at:)
				ifFalse: [ notFound
						add: (Dictionary
								newFrom: {'type' -> 'method'.
										'reason' -> 'Invalid method specification'.
										'spec' -> spec printString}) ].
			className := spec
					at: 'className'
					ifAbsent: [ notFound
							add: (Dictionary
									newFrom: {'type' -> 'method'.
											'reason' -> 'Missing className in method specification'.
											'spec' -> spec printString}) ].
			methodName := spec
					at: 'methodName'
					ifAbsent: [ notFound
							add: (Dictionary
									newFrom: {'type' -> 'method'.
											'className' -> className asString.
											'reason' -> 'Missing methodName in method specification'}).
						nil ].
			classSide := spec at: 'classSide' ifAbsent: [ false ].
			symbolName := className asString asSymbol.
			class := Smalltalk globals
					at: symbolName
					ifAbsent: [ notFound
							add: (Dictionary
									newFrom: {'type' -> 'method'.
											'className' -> className asString.
											'methodName' -> methodName asString.
											'reason' -> 'Class not found'}).
						nil ].
			class
				ifNotNil: [ targetClass := (classSide = true or: [ classSide asString = 'true' ])
							ifTrue: [ class class ]
							ifFalse: [ class ].
					method := targetClass
							compiledMethodAt: methodName asString asSymbol
							ifAbsent: [ notFound
									add: (Dictionary
											newFrom: {'type' -> 'method'.
													'className' -> className asString.
													'methodName' -> methodName asString.
													'reason' -> 'Method not found'}).
								nil ].
					method
						ifNotNil: [ (method pragmas anySatisfy: [ :pragma | pragma selector = #gtExample ])
								ifFalse: [ notFound
										add: (Dictionary
												newFrom: {'type' -> 'method'.
														'className' -> className asString.
														'methodName' -> methodName asString.
														'reason' -> 'Method is not an example'}) ].
							example := method gtExample.
							example
								ifNil: [ notFound
										add: (Dictionary
												newFrom: {'type' -> 'method'.
														'className' -> className asString.
														'methodName' -> methodName asString.
														'reason' -> 'Could not build example'}) ].
							examplesSet add: example ] ] ]
]

{ #category : #'as yet unclassified' }
GtLToolForExampleClassesRun >> extractExamplesFromPackagesFrom: arguments in: examplesSet reportingNotFoundIn: notFound [
	| packageNames |
	packageNames := (arguments at: 'packageNames' ifAbsent: [ #() ]) asArray.
	packageNames
		do: [ :packageName | 
			| package |
			package := RPackageOrganizer default
					packageNamed: packageName asString
					ifAbsent: [ notFound
							add: (Dictionary
									newFrom: {'type' -> 'package'.
											'name' -> packageName asString.
											'reason' -> 'Package not found'}).
						nil ].
			package
				ifNotNil: [ package gtExamplesAllContained do: [ :example | examplesSet add: example ] ] ]
]

{ #category : #'llm-generated' }
GtLToolForExampleClassesRun >> name [
	^ 'examplesInClassesRun'
]

{ #category : #'llm-generated' }
GtLToolForExampleClassesRun >> parametersDescription [
	^ #('classNames')
]

{ #category : #accessing }
GtLToolForExampleClassesRun >> privatePerformToolCall: aToolCall [
	| arguments classNames examples notFound details |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	classNames := arguments
			at: 'classNames'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'classNames' ].

	examples := IdentitySet new.
	notFound := OrderedCollection new.
	self
		extractExamplesFromClassesFrom: (classNames findTokens: String space)
		in: examples
		reportingNotFoundIn: notFound.
	details := OrderedCollection new.
	examples
		do: [ :example | 
			| exampleWithResult |
			[ | detail |
			exampleWithResult := example asExampleWithResult.
			exampleWithResult hasNoTestPragma ifFalse: [ exampleWithResult run ].
			detail := GtLExampleWithResultDomainObject new
					exampleWithResult: exampleWithResult.
			details add: detail ] on: Error do: [ :ex | ex return: nil ] ].

	^ GtLExampleWithResultsDomainObject new
		exampleWithResults: details asArray;
		notFoundClassNames: notFound asArray
]
