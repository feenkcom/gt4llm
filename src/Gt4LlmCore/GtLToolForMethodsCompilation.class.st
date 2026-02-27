Class {
	#name : #GtLToolForMethodsCompilation,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #visiting }
GtLToolForMethodsCompilation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodsCompilation: self
]

{ #category : #accessing }
GtLToolForMethodsCompilation >> description [
	^ 'Compiles multiple method sources across classes and reports each result.'
]

{ #category : #private }
GtLToolForMethodsCompilation >> methodResultFromDescriptor: descriptor [
	| className class classSideValue source protocol selector methodNode oldSourceCode |
	className := descriptor
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: descriptor;
					missingArgument: 'className' ].
	class := className
			asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].
	classSideValue := descriptor at: 'classSide' ifAbsent: [ false ].
	(classSideValue = true or: [ classSideValue asString = 'true' ])
		ifTrue: [ class := class class ].
	source := descriptor
			at: 'sourceCode'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: descriptor;
					missingArgument: 'sourceCode' ].
	source := source asString trimBoth.
	source isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: descriptor;
				missingArgument: 'sourceCode' ].
	protocol := descriptor at: 'protocol' ifAbsent: [ 'as yet unclassified' ].
	protocol isEmpty ifTrue: [ protocol := 'as yet unclassified' ].
	methodNode := [ GtPharoParser
			parse: source
			startingAt: GtPharoParser startingStateForMethod ]
			on: Error
			do: [ :error | 
				^ GtLMethodCompilationExceptionDomainObject new
					freeze: error;
					targetClass: class;
					protocolName: protocol;
					sourceCode: source;
					description: 'Syntax error while parsing the given method source code' ].
	oldSourceCode := (methodNode notNil
			and: [ methodNode selector notNil
					and: [ class includesSelector: methodNode selector ] ])
			ifTrue: [ (class >> methodNode selector) sourceCode ]
			ifFalse: [ nil ].
	selector := [ [ class compile: source classified: protocol ]
			on: CodeError
			do: [ :notification | 
				^ GtLMethodCompilationExceptionDomainObject new
					freeze: notification;
					targetClass: class;
					protocolName: protocol;
					sourceCode: source;
					description: 'Syntax error while compiling given method source code' ] ]
			on: Error
			do: [ :error | 
				^ GtLMethodCompilationExceptionDomainObject new
					freeze: error;
					targetClass: class;
					protocolName: protocol;
					sourceCode: source;
					description: 'Compilation error while compiling given method source code' ].
	^ GtLMethodDomainObject new
		method: (class methodDict at: selector);
		oldSourceCode: oldSourceCode;
		newSourceCode: (class methodDict at: selector) sourceCode
]

{ #category : #private }
GtLToolForMethodsCompilation >> methodResultsFrom: methodsArgument ifInvalid: invalidBlock [
	| results incorrectItems |
	results := OrderedCollection new: methodsArgument size.
	incorrectItems := OrderedCollection new.
	methodsArgument do: [ :eachDescriptor |
		eachDescriptor isDictionary
			ifFalse: [ incorrectItems add: eachDescriptor ]
			ifTrue: [ results add: (self methodResultFromDescriptor: eachDescriptor) ] ].
	incorrectItems isEmpty ifFalse: [ ^ invalidBlock value: incorrectItems ].
	^ results asArray
]

{ #category : #accessing }
GtLToolForMethodsCompilation >> methodsListJsonSchemaDictionary [
	| methodSchema |
	methodSchema := {'type' -> 'object'.
			'properties'
				-> {'className' -> {'type' -> 'string'} asDictionary.
						'sourceCode' -> {'type' -> 'string'} asDictionary.
						'protocol' -> {'type' -> 'string'} asDictionary.
						'classSide' -> {'type' -> 'boolean'} asDictionary} asDictionary.
			'required' -> #('className' 'sourceCode' 'protocol' 'classSide').
			'additionalProperties' -> false} asDictionary.
	^ {'type' -> 'object'.
		'properties'
			-> {'methods'
						-> {'type' -> 'array'.
								'items' -> methodSchema} asDictionary} asDictionary.
		'required' -> #('methods').
		'additionalProperties' -> false} asDictionary
]

{ #category : #accessing }
GtLToolForMethodsCompilation >> name [
	^ 'compileMethods'
]

{ #category : #accessing }
GtLToolForMethodsCompilation >> parametersDescription [
	^ GtLResponseJsonSchemaFormat new
			name: 'Parameters'; 
			schemaDictionary: self methodsListJsonSchemaDictionary
]

{ #category : #execution }
GtLToolForMethodsCompilation >> privatePerformToolCall: aToolCall [
	| arguments methodsArgument methods |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodsArgument := arguments
			at: 'methods'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'methods' ].
	(methodsArgument isCollection and: [ methodsArgument isString not ])
		ifFalse: [ ^ GtLIncorrectArgumentTypeDomainObject new
				argumentName: 'methods';
				argumentValue: methodsArgument;
				expectedArgumentValueKind: Array ].
	methods := self
			methodResultsFrom: methodsArgument
			ifInvalid: [ :incorrectItems | 
				^ GtLIncorrectArgumentArrayItemDomainObject new
					argumentName: 'methods';
					argumentValue: methodsArgument;
					expectedItemKind: Dictionary;
					incorrectItems: incorrectItems ].
	^ GtLMethodsCompilationDomainObject new methods: methods
]
