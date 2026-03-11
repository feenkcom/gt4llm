"
Magritte-based tool for evaluating Smalltalk code and returning serialized results.
"
Class {
	#name : #GtLMagritteToolForSmalltalkCodeEvaluation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForSmalltalkCodeEvaluation >> bindingsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Bindings';
		accessor: #bindings;
		classes: { GtLSmalltalkCodeEvaluationBinding };
		beRequired
]

{ #category : #magritte }
GtLMagritteToolForSmalltalkCodeEvaluation >> codeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Code';
		accessor: #code;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForSmalltalkCodeEvaluation >> description [
	^ 'Executes the provided Smalltalk code and returns the serialized result as JSON. Do not compile code using this tool. Do not delete files using this tool. Use this tool only as a last resort to investigate objects.

Arguments:
- code: string
- bindings: array of binding objects with name and objectId (pass empty array if not needed)

Example JSON arguments:
{
  "code": "1 + 2",
  "bindings": []
}

Example JSON arguments with bindings:
{
  "code": "value + 2",
  "bindings": [{"name": "value", "objectId": "uuid-string"}]
}

Example JSON response:
{
  "code": "1 + 2",
  "objectValue": {
    "objectClassName": "SmallInteger",
    "superclassName": "Integer",
    "packageName": "Kernel",
    "objectPrintString": "3",
    "phlowViews": [{"methodName": "gtPrintFor:", "title": "Print"}],
    "allInstanceSlots": []
  },
  "objectId": "uuid-or-empty"
}

Example JSON error response:
{
  "code": "1 / 0",
  "errorMessage": "ZeroDivide",
  "errorClassName": "ZeroDivide",
  "whatFailed": "Error while evaluating smalltalk code",
  "stackTrace": "..."
}'
]

{ #category : #accessing }
GtLMagritteToolForSmalltalkCodeEvaluation >> name [
	^ 'smalltalkCodeEvaluation'
]

{ #category : #'tool execution' }
GtLMagritteToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments code bindings bindingsDictionary object objectId |
	arguments := aToolCall arguments.
	
	"Get the code"
	code := arguments at: 'code'.
	(code isNil or: [ code isString and: [ code trimBoth isEmpty ] ]) ifTrue: [ 
		^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'code' ].
	
	"Get the bindings"
	bindings := arguments at: 'bindings' ifAbsent: [ #() ].
	bindingsDictionary := nil.
	
	bindings ifNotEmpty: [
		anExecutionContext objectStorage
			ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'objectStorage' ].
		bindingsDictionary := Dictionary new.
		bindings do: [ :each |
			| bindingName bindingObjectId bindingObject |
			bindingName := each name.
			bindingObjectId := each objectId.
			
			"Validate objectId is present and not empty"
			(bindingObjectId isNil or: [ bindingObjectId isEmpty ])
				ifTrue: [ ^ GtLMissingDomainObject new objectName: (bindingObjectId ifNil: [ 'nil' ]) ].
			
			bindingObject := anExecutionContext objectStorage
				objectAt: bindingObjectId
				ifPresent: [ :storedObject | storedObject ]
				ifAbsent: [ ^ GtLMissingDomainObject new objectName: bindingObjectId ].
			bindingsDictionary at: (bindingName ifNil: [ '' ]) asSymbol put: bindingObject ] ].
	
	"Evaluate the code"
	object := [ | compiler |
		compiler := OpalCompiler new.
		bindingsDictionary ifNotNil: [ compiler bindings: bindingsDictionary ].
		compiler evaluate: code ]
	on: Error
	do: [ :ex |
		^ GtLSmalltalkCodeEvaluationExceptionResult new
			freeze: ex;
			whatFailed: 'Error while evaluating smalltalk code';
			code: code ].
	
	"Store the result object"
	objectId := anExecutionContext objectStorage ifNotNil: [ :aStorage |
		aStorage addNewObject: object ].
	
	"Return the result"
	^ GtLSmalltalkCodeEvaluationResult new
		code: code;
		object: object;
		objectValue: (GtLSerializedObjectValue fromObject: object);
		objectId: (objectId ifNil: [ '' ])
]
