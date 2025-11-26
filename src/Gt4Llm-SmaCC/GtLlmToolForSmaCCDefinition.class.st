Class {
	#name : #GtLlmToolForSmaCCDefinition,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-SmaCC-Tools'
}

{ #category : #accessing }
GtLlmToolForSmaCCDefinition class >> leJsonV4Name [
	^ #gtLlmToolForSmaCCDefinition
]

{ #category : #accessing }
GtLlmToolForSmaCCDefinition >> description [
	^ 'Returns the SmaCC grammar for a parser given a class name.'
]

{ #category : #accessing }
GtLlmToolForSmaCCDefinition >> name [
	^ 'gtSmaCCDefinition'
]

{ #category : #accessing }
GtLlmToolForSmaCCDefinition >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmToolForSmaCCDefinition >> privatePerformToolCall: aToolCall [
	| arguments className object serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
			at: 'className'
			ifAbsent: [ ^ 'Class name not provided' ].
	className ifNil: [ ^ 'Class name not provided' ].
	className := className asString.
	className isEmpty ifTrue: [ ^ 'Class name not provided' ].
	object := [ Dictionary new
			at: 'definition' put: className asSymbol asClass parserDefinitionString;
			yourself ] on: Error do: [ :ex | ^ 'Error: ' , String cr , ex stackString ].
	serializer := GtLlmValueSerializer new.
	^ STONJSON toStringPretty: object
]
