Class {
	#name : #GtLlmToolForSmaCCGrammar,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForSmaCCGrammar class >> leJsonV4Name [
	^ #gtLlmToolForSmaCCGrammar
]

{ #category : #accessing }
GtLlmToolForSmaCCGrammar >> description [
	^ 'Parses a SmaCC grammar for proper syntax'
]

{ #category : #accessing }
GtLlmToolForSmaCCGrammar >> name [
	^ 'gtSmaCCGrammar'
]

{ #category : #accessing }
GtLlmToolForSmaCCGrammar >> parameters [
	^ #('grammar')
]

{ #category : #'llm-generated' }
GtLlmToolForSmaCCGrammar >> privatePerformToolCall: aToolCall [
	| arguments grammar object serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	grammar := arguments at: 'grammar' ifAbsent: [ ^ 'Grammar not provided' ].
	grammar ifNil: [ ^ 'Grammar not provided' ].
	grammar := grammar asString.
	grammar isEmpty ifTrue: [ ^ 'Grammar not provided' ].
	object := [ SmaCCDefinitionParser parse: grammar ]
			on: Error
			do: [ :ex | ^ 'Error: ' , String cr , ex stackString ].
	serializer := GtLlmValueSerializer new.
	^ STONJSON toStringPretty: (serializer serializeValue: object)
]
