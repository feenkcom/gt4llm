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
		beOptional
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
	^ 'Executes the provided Smalltalk code. It returns
1. if it succeeds: 
- the resulting object as one or more JSON or image entries, each representing a view of the resulting object. Look at all of them to interpret the result.
- the object id that you can use as reference for other tool calls.
- the playgroundPageReference to the contextual playground page. Use that page to look for object specific snippets and explanations.
2. if there is an exception, it gets the errorDetails (errorMessage, stackTrace, errorClass). It can also get other JSON or image entries each representing a view of the exception. Look at all of them to interpret the result.

Do not compile code using this tool. Do not delete files using this tool. Use this tool only as a last resort to investigate objects.

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
  "objectId": "uuid-or-empty",
  "playgroundPageReference" : {
		"databaseId" : "auhvwh3wo4eisu1kci9jdew92",
		"pageId" : "9fxzw74ztlk895vquuwasakr"
	}
}

Example JSON error response:
{
	"errorReason" : "Error while evaluating smalltalk code",
	"errorDetails" : {
		"stackTrace" : "...",
		"errorClass" : "ZeroDivide",
		"errorMessage" : "ZeroDivide"
	},
	"code" : "1 / 0"
}'
]

{ #category : #accessing }
GtLMagritteToolForSmalltalkCodeEvaluation >> name [
	^ 'smalltalkCodeEvaluation'
]

{ #category : #private }
GtLMagritteToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments code bindings bindingsDictionary object |
	arguments := aToolCall arguments.
	code := arguments at: 'code'.
	(code isNil or: [ code isString and: [ code trimBoth isEmpty ] ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'code' ].
	bindings := arguments at: 'bindings' ifAbsent: [ #() ].
	bindingsDictionary := nil.
	bindings
		ifNotEmpty: [ anExecutionContext objectStorage
				ifNil: [ ^ GtLMissingInformationDomainObject new missingModelName: 'objectStorage' ].
			bindingsDictionary := Dictionary new.
			bindings
				do: [ :each | 
					| bindingName bindingObjectId bindingObject |
					bindingName := each name.
					bindingObjectId := each objectId.
					(bindingObjectId isNil or: [ bindingObjectId isEmpty ])
						ifTrue: [ ^ GtLMissingDomainObject new objectName: (bindingObjectId ifNil: [ 'nil' ]) ].
					bindingObject := anExecutionContext objectStorage
							objectAt: bindingObjectId
							ifPresent: [ :storedObject | storedObject ]
							ifAbsent: [ ^ GtLMissingDomainObject new objectName: bindingObjectId ].
					bindingsDictionary
						at: (bindingName ifNil: [ '' ]) asSymbol
						put: bindingObject ] ].

	object := [ | compiler |
		compiler := OpalCompiler new.
		bindingsDictionary ifNotNil: [ compiler bindings: bindingsDictionary ].
		compiler evaluate: code ]
			on: Error
			do: [ :ex | 
				^(GtLSmalltalkCodeEvaluationExceptionDomainObject freeze: ex)
							errorReason: 'Error while evaluating smalltalk code';
							code: code;
							updateForToolCall: aToolCall withExecutionContext: anExecutionContext;
							yourself ].
	
	^ (GtLSmalltalkCodeEvaluationResult forObject: object)
			code: code;
			updateForToolCall: aToolCall withExecutionContext: anExecutionContext;
			yourself
]
