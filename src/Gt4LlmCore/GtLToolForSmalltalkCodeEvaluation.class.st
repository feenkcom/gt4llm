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

{ #category : #'llm-generated' }
GtLToolForSmalltalkCodeEvaluation >> parametersDescription [
	^ #('code')
]

{ #category : #private }
GtLToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall [
	| arguments code object |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments
		at: 'code'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'code' ].
	code
		ifNil: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'code' ].
	code := code asString trimBoth.
	code isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'code' ].
	object := [ OpalCompiler new evaluate: code ]
		on: Error
		do: [ :ex |
			^ GtLExceptionDomainObject new
				freeze: ex;
				description: 'Error while evaluating smalltalk code' ].

	^ GtLSmalltalkCodeEvaluationDomainObject new
		code: code;
		value: object
]
