Class {
	#name : #GtLToolForMethodsRemoval,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #visiting }
GtLToolForMethodsRemoval >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodsRemoval: self
]

{ #category : #accessing }
GtLToolForMethodsRemoval >> description [
	^ 'Removes multiple methods across classes and reports each result.'
]

{ #category : #private }
GtLToolForMethodsRemoval >> methodResultFromDescriptor: descriptor [
	| classNameValue classNameString classSymbol targetClass classSideValue classSide behavior methodNameValue methodNameString selector compiledMethod missingName |
	classNameValue := descriptor
		at: 'className'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: descriptor;
			missingArgument: 'className' ].
	classNameString := classNameValue asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: descriptor;
			missingArgument: 'className' ].
	classSymbol := classNameString asSymbol.
	targetClass := Smalltalk globals
		at: classSymbol
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: classNameString ].
	classSideValue := descriptor at: 'classSide' ifAbsent: [ false ].
	classSide := classSideValue = true.
	classSide
		ifFalse: [ (classSideValue notNil and: [ classSideValue respondsTo: #asString ])
			ifTrue: [ classSide := classSideValue asString asLowercase = 'true' ] ].
	behavior := classSide
		ifTrue: [ targetClass class ]
		ifFalse: [ targetClass ].
	methodNameValue := descriptor
		at: 'methodName'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: descriptor;
			missingArgument: 'methodName' ].
	methodNameString := methodNameValue asString trimBoth.
	methodNameString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: descriptor;
			missingArgument: 'methodName' ].
	selector := methodNameString asSymbol.
	compiledMethod := behavior
		compiledMethodAt: selector
		ifAbsent: [
			missingName := behavior name asString , '>>' , methodNameString.
			^ GtLMissingDomainObject new objectName: missingName ].
	[ behavior removeSelector: selector ]
		on: Error
		do: [ :ex |
			^ GtLExceptionDomainObject new
				freeze: ex;
				description: 'Error while removing method';
				yourself ].
	^ GtLMethodDomainObject new method: compiledMethod
]

{ #category : #private }
GtLToolForMethodsRemoval >> methodResultsFrom: methodsArgument ifInvalid: invalidBlock [
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
GtLToolForMethodsRemoval >> methodsListJsonSchemaDictionary [
	| methodSchema |
	methodSchema := {'type' -> 'object'.
		'properties' -> {
			'className' -> {'type' -> 'string'} asDictionary.
			'methodName' -> {'type' -> 'string'} asDictionary.
			'classSide' -> {'type' -> 'boolean'} asDictionary
		} asDictionary.
		'required' -> #('className' 'methodName' 'classSide').
		'additionalProperties' -> false
	} asDictionary.
	^  {
			'type' -> 'object'.
			'properties' -> {
				'methods' -> {
					'type' -> 'array'.
					'items' -> methodSchema
				} asDictionary
			} asDictionary.
			'required' -> #('methods').
			'additionalProperties' -> false
		} asDictionary
]

{ #category : #accessing }
GtLToolForMethodsRemoval >> name [
	^ 'removeMethods'
]

{ #category : #accessing }
GtLToolForMethodsRemoval >> parametersDescription [
	^ GtLResponseJsonSchemaFormat new
			name: 'Parameters'; 
			schemaDictionary: self methodsListJsonSchemaDictionary
]

{ #category : #api }
GtLToolForMethodsRemoval >> privatePerformToolCall: aToolCall [
	| arguments methodsArgument methods |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodsArgument := arguments
			at: 'methods'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'methods' ].
	(methodsArgument isCollection and: [ methodsArgument isString not ])
		ifFalse: [ ^ GtLIncorrectArgumentValueDomainObject new
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
	^ GtLMethodsRemovalDomainObject new methods: methods
]
