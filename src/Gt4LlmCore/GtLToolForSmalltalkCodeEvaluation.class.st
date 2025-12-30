Class {
	#name : #GtLToolForSmalltalkCodeEvaluation,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLToolForSmalltalkCodeEvaluation class >> leJsonV4Name [
	^ #gtLlmToolForSmalltalkCodeEvaluation
]

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
GtLToolForSmalltalkCodeEvaluation >> parameters [
	^ #('code')
]

{ #category : #'llm-generated' }
GtLToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall [
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
