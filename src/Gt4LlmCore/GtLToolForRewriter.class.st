Class {
	#name : #GtLToolForRewriter,
	#superclass : #GtLAbstractFunctionTool,
	#category : 'Gt4LlmCore-Tools'
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
	code := arguments
			at: 'rewrite'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'rewrite' ].
	code
		ifNil: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'rewrite' ].
	code := code asString.
	code isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'rewrite' ].
	object := [ OpalCompiler new evaluate: code ]
			on: Error
			do: [ :ex | 
				^ GtLExceptionDomainObject new
					freeze: ex;
					description: 'Rewriter code execution failed' ].
	^ GtLValueDomainObject new value: object
]
