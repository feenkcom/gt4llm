Class {
	#name : #GtLlmToolForRewriter,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : 'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForRewriter class >> leJsonV4Name [
	^ #gtLlmToolForRewriter
]

{ #category : #accessing }
GtLlmToolForRewriter >> description [
	^ 'Evaluates a rewriter for proper syntax'
]

{ #category : #accessing }
GtLlmToolForRewriter >> name [
	^ 'gtRewriter'
]

{ #category : #accessing }
GtLlmToolForRewriter >> parameters [
	^ #('rewrite')
]

{ #category : #'llm-generated' }
GtLlmToolForRewriter >> privatePerformToolCall: aToolCall [
	| arguments code object serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments at: 'rewrite' ifAbsent: [ ^ 'Rewrite not provided' ].
	code ifNil: [ ^ 'Rewrite not provided' ].
	code := code asString.
	code isEmpty ifTrue: [ ^ 'Rewrite not provided' ].
	object := [ OpalCompiler new evaluate: code ]
		on: Error
		do: [ :ex | ^ 'Error: ', String cr, ex stackString ].
	serializer := GtLlmValueSerializer new.
	^ STONJSON toStringPretty: (serializer serializeValue: object)
]
