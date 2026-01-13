Class {
	#name : #GtLToolForRewriter,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForRewriter class >> leJsonV4Name [
	^ #gtLToolForRewriter
]

{ #category : #accessing }
GtLToolForRewriter >> description [
	^ 'Evaluates a rewriter for proper syntax'
]

{ #category : #accessing }
GtLToolForRewriter >> name [
	^ 'gtRewriter'
]

{ #category : #accessing }
GtLToolForRewriter >> parameters [
	^ #('rewrite')
]

{ #category : #'llm-generated' }
GtLToolForRewriter >> privatePerformToolCall: aToolCall [
	| arguments code object serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments at: 'rewrite' ifAbsent: [ ^ 'Rewrite not provided' ].
	code ifNil: [ ^ 'Rewrite not provided' ].
	code := code asString.
	code isEmpty ifTrue: [ ^ 'Rewrite not provided' ].
	object := [ OpalCompiler new evaluate: code ]
		on: Error
		do: [ :ex | ^ 'Error: ', String cr, ex stackString ].
	serializer := GtLValueSerializer new.
	^ STONJSON toStringPretty: (serializer serializeValue: object)
]
