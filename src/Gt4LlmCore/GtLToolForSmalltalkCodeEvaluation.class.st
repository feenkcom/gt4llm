Class {
	#name : #GtLToolForSmalltalkCodeEvaluation,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLToolForSmalltalkCodeEvaluation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSmalltalkCodeEvaluation: self
]

{ #category : #'llm-generated' }
GtLToolForSmalltalkCodeEvaluation >> description [
	^ 'Executes the provided Smalltalk code and returns the serialized result as JSON. Do not compile code using this tool. Do not delete files using this tool. Use this tool only as a last resort to investigate objects.'
]

{ #category : #'llm-generated' }
GtLToolForSmalltalkCodeEvaluation >> name [
	^ 'smalltalkCodeEvaluation'
]

{ #category : #accessing }
GtLToolForSmalltalkCodeEvaluation >> parametersDescription [
	^ GtLResponseJsonSchemaFormat new
		name: 'Parameters';
		schemaDictionary: self parametersJsonSchemaDictionary
]

{ #category : #accessing }
GtLToolForSmalltalkCodeEvaluation >> parametersJsonSchemaDictionary [
	| bindingSchema |
	bindingSchema := {
		'type' -> 'object'.
		'properties' -> {
			'name' -> {'type' -> 'string'} asDictionary.
			'objectId' -> {'type' -> 'string'} asDictionary
		} asDictionary.
		'required' -> #('name' 'objectId').
		'additionalProperties' -> false
	} asDictionary.
	^ {
		'type' -> 'object'.
		'properties' -> {
			'code' -> {'type' -> 'string'} asDictionary.
			'bindings' -> {
				'type' -> 'array'.
				'items' -> bindingSchema
			} asDictionary
		} asDictionary.
		'required' -> #('code').
		'additionalProperties' -> false
	} asDictionary
]

{ #category : #private }
GtLToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments code object objectId bindings bindingsDictionary |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments
		at: 'code'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'code' ].
	code
		ifNil: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'code' ].
	code := code asString trimBoth.
	code isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'code' ].
	bindings := arguments at: 'bindings' ifAbsent: [ nil ].
	bindingsDictionary := nil.
	(bindings notNil and: [ bindings notEmpty ]) ifTrue: [
		anExecutionContext objectStorage
			ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'objectStorage' ].
		bindingsDictionary := Dictionary new.
		bindings do: [ :each |
			| bindingName bindingObjectId bindingObject |
			bindingName := each
				at: 'name'
				ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'name' ].
			bindingObjectId := each
				at: 'objectId'
				ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'objectId' ].
			bindingObject := anExecutionContext objectStorage
				objectAt: bindingObjectId
				ifPresent: [ :storedObject | storedObject ]
				ifAbsent: [ ^ GtLMissingDomainObject new objectName: bindingObjectId ].
			bindingsDictionary at: bindingName asSymbol put: bindingObject ] ].
	object := [ | compiler |
		compiler := OpalCompiler new.
		bindingsDictionary ifNotNil: [ compiler bindings: bindingsDictionary ].
		compiler evaluate: code ]
		on: Error
		do: [ :ex |
			^ GtLSmalltalkCodeEvaluationExceptionDomainObject new
				freeze: ex;
				description: 'Error while evaluating smalltalk code';
				code: code ].

	objectId := anExecutionContext objectStorage ifNotNil: [ :aStorage |
		aStorage addNewObject: object ].
				
	^ GtLSmalltalkCodeEvaluationDomainObject new
		code: code;
		object: object;
		objectId: objectId
]
