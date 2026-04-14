Class {
	#name : #GtLlmToolForSmalltalkCodeEvaluation,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit-Tools'
}

{ #category : #'llm-generated' }
GtLlmToolForSmalltalkCodeEvaluation class >> leJsonV4Name [
	^ #gtLlmToolForSmalltalkCodeEvaluation
]

{ #category : #'llm-generated' }
GtLlmToolForSmalltalkCodeEvaluation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSmalltalkCodeEvaluation: self
]

{ #category : #'llm-generated' }
GtLlmToolForSmalltalkCodeEvaluation >> description [
	^ 'Executes the provided Smalltalk code and returns the serialized result as JSON. Do not compile code using this tool. Do not delete files using this tool. Use this tool only as a last resort to investigate objects.'
]

{ #category : #'llm-generated' }
GtLlmToolForSmalltalkCodeEvaluation >> name [
	^ 'smalltalkCodeEvaluation'
]

{ #category : #'llm-generated' }
GtLlmToolForSmalltalkCodeEvaluation >> parameters [
	^ #('code')
]

{ #category : #'llm-generated' }
GtLlmToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall [
	| arguments code object serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments at: 'code' ifAbsent: [ ^ 'Code not provided' ].
	code ifNil: [ ^ 'Code not provided' ].
	code := code asString.
	code isEmpty ifTrue: [ ^ 'Code not provided' ].
	object := [ OpalCompiler new evaluate: code ]
		on: Error
		do: [ :ex | ^ 'Error: ', String cr, ex stackString ].
	serializer := GtLlmValueSerializer new.
	^ STONJSON toStringPretty: (serializer serializeValue: object)
]
