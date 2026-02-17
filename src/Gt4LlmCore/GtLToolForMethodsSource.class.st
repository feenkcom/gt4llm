Class {
	#name : #GtLToolForMethodsSource,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodsSource class >> leJsonV4Name [
	^ #gtLToolForMethodsSource
]

{ #category : #visiting }
GtLToolForMethodsSource >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodsSource: self
]

{ #category : #accessing }
GtLToolForMethodsSource >> description [
	^ 'Gets source code for multiple methods. Arguments must provide a methods array of method descriptors with className, methodName, and optional classSide values.

Example JSON arguments:
{
  "methods": [
    {"className": "Collection", "methodName": "withAll:", "classSide": true},
    {"className": "GtLToolForMethodImplementors", "methodName": "privatePerformToolCall:", "classSide": false}
  ]
}

Example JSON response:
{
  "methods": [
    {"methodClass": "Collection class", "selector": "withAll:", "method": "Collection class>>#withAll:", "sourceCode": "..."},
    {"methodClass": "GtLToolForMethodImplementors", "selector": "privatePerformToolCall:", "method": "GtLToolForMethodImplementors>>#privatePerformToolCall:", "sourceCode": "..."}
  ]
}'
]

{ #category : #private }
GtLToolForMethodsSource >> methodSourceFromDescriptor: descriptor [
	| className methodName classSide class methodSymbol method |
	className := descriptor
		at: 'className'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: descriptor;
				missingArgument: 'className' ].
	class := className
		asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].
	methodName := descriptor
		at: 'methodName'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: descriptor;
				missingArgument: 'methodName' ].
	classSide := descriptor
		at: 'classSide'
		ifPresent: [ :aValue | #(true 'true' 't') includes: aValue ]
		ifAbsent: [ false ].
	classSide ifTrue: [ class := class class ].
	methodSymbol := methodName asSymbol.
	method := class lookupSelector: methodSymbol.
	method
		ifNil: [ ^ GtLMissingDomainObject new
				objectName: ('{1}{2}>>#{3}'
					format: {className.
						classSide ifTrue: [ ' class' ] ifFalse: [ '' ].
						methodName}) ].
	method isSourceSearchable 
		ifFalse: [ ^GtLNotSourceSearchableMethodDomainObject new 
			method: method ].
	^ GtLMethodDomainObject new method: method
]

{ #category : #private }
GtLToolForMethodsSource >> methodSourcesFrom: methodsArgument ifInvalid: invalidBlock [
	| methodSources incorrectItems |
	methodSources := OrderedCollection new: methodsArgument size.
	incorrectItems := OrderedCollection new.
	methodsArgument do: [ :eachDescriptor | 
		| result |
		eachDescriptor isDictionary
			ifFalse: [
				incorrectItems add: eachDescriptor ]
			ifTrue: [
				result := self methodSourceFromDescriptor: eachDescriptor.
				methodSources add: result ] ].
	incorrectItems isEmpty
		ifFalse: [ ^ invalidBlock value: incorrectItems ].
	^ methodSources asArray
]

{ #category : #accessing }
GtLToolForMethodsSource >> methodsListJsonSchemaDictionary [
	| methodSchema |
	methodSchema := {
		'type' -> 'object'.
		'properties' ->{
				'className' -> {'type' -> 'string'} asDictionary.
				'methodName' -> {'type' -> 'string'} asDictionary.
				'classSide' -> {'type' -> 'boolean'} asDictionary} asDictionary.
		'required' -> #('className' 'methodName' 'classSide').
		'additionalProperties' -> false} asDictionary.
		
	^ {
			'type' -> 'object'.
			'properties' ->{
					'methods' ->{
						'type' -> 'array'.
						'items' -> methodSchema} asDictionary} asDictionary.
			'required' -> #('methods').
			'additionalProperties' -> false} asDictionary
]

{ #category : #accessing }
GtLToolForMethodsSource >> name [
	^ 'getCodeOfMethods'
]

{ #category : #accessing }
GtLToolForMethodsSource >> parametersDescription [
	^ GtLResponseJsonSchemaFormat new
			name: 'Parameters'; 
			schemaDictionary: self methodsListJsonSchemaDictionary
]

{ #category : #execution }
GtLToolForMethodsSource >> privatePerformToolCall: aToolCall [
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
			methodSourcesFrom: methodsArgument
			ifInvalid: [ :incorrectItems | 
				^ GtLIncorrectArgumentArrayItemDomainObject new
					argumentName: 'methods';
					argumentValue: methodsArgument;
					expectedItemKind: Dictionary;
					incorrectItems: incorrectItems ].
	^ GtLMethodsSourceDomainObject new methods: methods
]
