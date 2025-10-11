Class {
	#name : #GtLlmToolForExampleClassesRun,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForExampleClassesRun class >> leJsonV4Name [
	^ #gtLlmToolForExampleGroupRun
]

{ #category : #'llm-generated' }
GtLlmToolForExampleClassesRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForExampleGroupRun: self
]

{ #category : #'llm-generated' }
GtLlmToolForExampleClassesRun >> description [
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
GtLlmToolForExampleClassesRun >> extractExamplesFromClassesFrom: classNames in: examplesSet reportingNotFoundIn: notFound [
	classNames
		do: [ :className | 
			Smalltalk globals
				at: className asString asSymbol
				ifPresent: [ :class | 
					| factory |
					factory := GtExampleFactory new.
					factory sourceClass: class.
					factory gtExamplesContained do: [ :example | examplesSet add: example ] ]
				ifAbsent: [ notFound
						add: {'type' -> 'class'.
								'name' -> className asString.
								'reason' -> 'Class not found'} asDictionary ] ]
]

{ #category : #'as yet unclassified' }
GtLlmToolForExampleClassesRun >> extractExamplesFromMethodsFrom: arguments in: examplesSet reportingNotFoundIn: notFound [
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
GtLlmToolForExampleClassesRun >> extractExamplesFromPackagesFrom: arguments in: examplesSet reportingNotFoundIn: notFound [
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
GtLlmToolForExampleClassesRun >> name [
	^ 'examplesInClassesRun'
]

{ #category : #'llm-generated' }
GtLlmToolForExampleClassesRun >> parameters [
	^ #('classNames')
]

{ #category : #'as yet unclassified' }
GtLlmToolForExampleClassesRun >> privatePerformToolCall: aToolCall [
	| arguments examples notFound details summary successes failures errors skipped |
	arguments := aToolCall arguments.
	arguments ifNil: [ ^ 'Argument is empty' ].
	arguments at: 'classNames' ifAbsent: [ ^ 'classNames is not provided' ].
		
	examples := IdentitySet new.
	notFound := OrderedCollection new.
	self
		extractExamplesFromClassesFrom: ((arguments at: 'classNames') findTokens: String space)
		in: examples
		reportingNotFoundIn: notFound.
	details := OrderedCollection new.
	successes := 0.
	failures := 0.
	errors := 0.
	skipped := 0.
	examples
		do: [ :example | 
			| exampleWithResult status message |
			[ | detail |
			exampleWithResult := example asExampleWithResult
					run;
					yourself.
			exampleWithResult hasNoTestPragma
				ifTrue: [ skipped := skipped + 1.
					status := 'skipped' ]
				ifFalse: [ message := exampleWithResult returnValue printString.
					exampleWithResult isError
						ifTrue: [ errors := errors + 1.
							status := 'error' ];
						ifFalse: [ exampleWithResult isSuccess
								ifTrue: [ successes := successes + 1. status := 'success' ]
								ifFalse: [ failures := failures + 1 . exampleWithResult isFailure ifTrue: [ status := 'failure' ] ] ] ].
			detail := {'className' -> example methodClass name asString.
					'selector' -> example selector asString.
					'status' -> status.
					'result' -> message} asDictionary.
			details add: detail ]
				on: Error
				do: [ :ex | 
					status := 'error'.
					message := ex printString ] ].

	summary := {'total' -> details size.
			'successes' -> successes .
			'failures' -> failures .
			'errors' -> errors .
			'skips' -> skipped.
			'details' -> details asArray.
			'notFound' -> notFound} asDictionary.
	^ NeoJSONWriter toString: summary
]
