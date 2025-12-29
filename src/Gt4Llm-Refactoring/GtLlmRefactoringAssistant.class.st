Class {
	#name : #GtLlmRefactoringAssistant,
	#superclass : #GtLlmAssistant,
	#instVars : [
		'model',
		'transformations'
	],
	#category : #'Gt4Llm-Refactoring-Assistants'
}

{ #category : #private }
GtLlmRefactoringAssistant >> applyTransformations: anArray [
	| transformation |
	transformation := self transformationFrom: anArray.
	transformation primitiveExecute.
	^ transformation model
]

{ #category : #tools }
GtLlmRefactoringAssistant >> classLookupTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'rbLookupClass';
		parameters: {'className'};
		description: 'Get the details of a class as JSON.';
		block: [ :functionCall | 
			(functionCall arguments ifNil: [ Dictionary new ])
				at: 'className'
				ifPresent: [ :query | 
					(model classNamed: query)
						ifNil: [ 'Class not found' ]
						ifNotNil: [ :c | 
							STONJSON
								toString: {'class' -> c name.
										'superclass'
											-> (c superclass ifNil: [ nil ] ifNotNil: [ :spr | spr name ]).
										'package' -> c packageName.
										'instanceSlots' -> c instanceVariableNames asArray.
										'classSlots' -> c classSide instanceVariableNames asArray.
										'allInstanceMethods' -> c selectors asArray.
										'allClassMethods' -> c classSide selectors asArray} asDictionary ] ]
				ifAbsent: [ 'Class name not provided' ] ]
]

{ #category : #private }
GtLlmRefactoringAssistant >> classNames [
	| names |
	names := OrderedCollection new.
	model allClassesDo: [ :each | each isMeta ifFalse: [ names add: each name ] ].
	^ names
]

{ #category : #tools }
GtLlmRefactoringAssistant >> classReferencesTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'rbClassReferences';
		parameters: {'className'};
		description: 'Search the image for the references to the given class';
		block: [ :functionCall | 
			(functionCall arguments ifNil: [ Dictionary new ])
				at: 'className'
				ifPresent: [ :query | 
					(model classNamed: query)
						ifNil: [ 'Class not found' ]
						ifNotNil: [ :c | 
							String
								streamContents: [ :stream | 
									model
										allReferencesToClass: c
										do: [ :each | 
											stream << each modelClass name.
											each modelClass isMeta ifTrue: [ stream << ' class' ].
											stream << '>>#' << each selector << String cr ] ] ] ]
				ifAbsent: [ 'Class name not provided' ] ]
]

{ #category : #tools }
GtLlmRefactoringAssistant >> classSearchTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'rbSearchForClasses';
		parameters: {'query'};
		description: 'Searches for classes by name matching the query substring (case-insensitive).';
		block: [ :functionCall | 
			(functionCall arguments ifNil: [ Dictionary new ])
				at: 'query'
				ifPresent: [ :query | 
					STONJSON
						toString: (GtSpotterSubstringsFilter new
								withWordsSplitter;
								beCaseSensitiveByCapitalization;
								applyInScope: self classNames asAsyncStream
									context: (GtSpotterContext new searchQuery: query)) toArray wait ]
				ifAbsent: [ 'Query not provided' ] ]
]

{ #category : #tools }
GtLlmRefactoringAssistant >> classSubclassesTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'rbClassSubclasses';
		parameters: {'className'};
		description: 'Retrieve all subclasses of the given class';
		block: [ :functionCall | 
			(functionCall arguments ifNil: [ Dictionary new ])
				at: 'className'
				ifPresent: [ :query | 
					| subclassNames |
					(model classNamed: query)
						ifNil: [ 'Class not found' ]
						ifNotNil: [ :c | 
							subclassNames := c subclasses collect: [ :each | each name asString ].
							subclassNames isEmpty
								ifTrue: [ 'No subclasses found' ]
								ifFalse: [ Character cr join: subclassNames ] ] ]
				ifAbsent: [ 'Class name not provided' ] ]
]

{ #category : #private }
GtLlmRefactoringAssistant >> exampleTransformationsJSON [
	^ STONJSON
		toStringPretty: (self transformations asArray
				collect: [ :each | 
					each example copy
						at: 'type' put: each name;
						yourself ])
]

{ #category : #initialization }
GtLlmRefactoringAssistant >> initialize [
	super initialize.
	model := GtRBNamespace new
]

{ #category : #tools }
GtLlmRefactoringAssistant >> methodImplementorsTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'rbMethodImplementors';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that implement it.';
		block: [ :functionCall | 
			(functionCall arguments ifNil: [ Dictionary new ])
				at: 'methodName'
				ifPresent: [ :query | 
					(String
						streamContents: [ :stream | 
							model
								allImplementorsOf: query asSymbol
								do: [ :each | 
									stream << each name.
									each isMeta ifTrue: [ stream << ' class' ].
									stream cr ] ]) ifEmpty: [ 'No implementors found' ] ]
				ifAbsent: [ 'Method name not provided' ] ]
]

{ #category : #tools }
GtLlmRefactoringAssistant >> methodReferencesTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'rbMethodReferences';
		parameters: {'selector'};
		description: 'Search the image for the senders of the given selector (maximum 100)';
		block: [ :functionCall | 
			(functionCall arguments ifNil: [ Dictionary new ])
				at: 'selector'
				ifPresent: [ :query | self sendersOf: query ]
				ifAbsent: [ 'Selector not provided' ] ]
]

{ #category : #tools }
GtLlmRefactoringAssistant >> methodSourceTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'rbMethodSource';
		parameters: #('className' 'methodName' 'classSide');
		description: 'Gets a method by name and returns its source code. The third argument (classSide) should be true if the method is on the class side. It should be false if the method if on the instance side.';
		block: [ :functionCall | 
			| arguments |
			arguments := functionCall arguments ifNil: [ Dictionary new ].
			arguments
				at: 'className'
				ifPresent: [ :cn | 
					arguments
						at: 'methodName'
						ifPresent: [ :sel | 
							| class |
							(model classNamed: cn)
								ifNil: [ 'Class not found' ]
								ifNotNil: [ :cls | 
									class := (#('true' true)
											includes: (arguments at: 'classSide' ifAbsent: [ false ]))
											ifTrue: [ cls classSide ]
											ifFalse: [ cls ].
									(class methodFor: sel asSymbol)
										ifNil: [ 'Method not found' ]
										ifNotNil: [ :m | m source ] ] ]
						ifAbsent: [ 'Method name not provided' ] ]
				ifAbsent: [ 'Class name not provided' ] ]
]

{ #category : #formats }
GtLlmRefactoringAssistant >> refactoringDescription [
	<gtLlmAssistantFormat>
	| stream |
	stream := WriteStream on: String new.
	stream
		<< 'The result is a JSON object that specifies an array of Pharo transformations that can be used to modify Pharo source code.'
		<< String cr << String cr << 'These are the available transformations:'
		<< String cr << String cr.
	(self transformations asSortedCollection: [ :a :b | a name < b name ])
		do: [ :each | stream << '* ' << each name << ': ' << each description << String cr ].
	stream << String cr << 'Example:' << String cr << '```json' << String cr
		<< self exampleTransformationsJSON << String cr << '```' << String cr.
	^ GtLlmAssistantFormatDescription new
		name: 'Pharo Transformations';
		priority: 10;
		format: 'Code transformations for Pharo wrapped in a JSON array.';
		example: stream contents
]

{ #category : #private }
GtLlmRefactoringAssistant >> sendersOf: query [
	| stream count |
	stream := WriteStream on: String new.
	count := 0.
	model
		allReferencesTo: query asSymbol
		do: [ :each | 
			stream << each modelClass name.
			each modelClass isMeta ifTrue: [ stream << ' class' ].
			stream << '>>#' << each selector << String cr.
			count := count + 1.
			count = 100 ifTrue: [ ^ stream contents ] ].
	count = 0 ifTrue: [ ^ 'No references found' ].
	^ stream contents
]

{ #category : #private }
GtLlmRefactoringAssistant >> transformationFor: aDictionary inModel: aRBNamespace [
	^ (self transformations at: (aDictionary at: 'type')) transformation
		cull: aRBNamespace
		cull: aDictionary
]

{ #category : #private }
GtLlmRefactoringAssistant >> transformationFrom: anArray [
	| ns |
	ns := GtRBNamespace new.
	^ GtRBCompositeTransformation new
		model: ns;
		refactorings: (anArray collect: [ :each | self transformationFor: each inModel: ns ]);
		yourself
]

{ #category : #private }
GtLlmRefactoringAssistant >> transformations [
	^ transformations
		ifNil: [ transformations := Dictionary new.
			((Pragma allNamed: #gtLlmTransformationDescription)
				collect: [ :each | 
					(each method numArgs = 0 and: [ each method gtIsActive ])
						ifTrue: [ each method methodClass isClassSide
								ifTrue: [ each method
										valueWithReceiver: each method methodClass instanceSide
										arguments: #() ]
								ifFalse: [ (self isKindOf: each method methodClass)
										ifTrue: [ each method valueWithReceiver: self arguments: #() ] ] ] ])
				do: [ :each | each notNil ifTrue: [ transformations at: each name put: each ] ].
			transformations ]
]
