Class {
	#name : #GtLlmFunctionCallSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'functionCall',
		'tool'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmFunctionCallSignal >> functionCall: aFunctionCall [ 
	functionCall := aFunctionCall
]

{ #category : #'as yet unclassified' }
GtLlmFunctionCallSignal >> tool: aTool [ 
	tool := aTool
]
