Class {
	#name : #GtLlmSmalltalkExecutionChecker,
	#superclass : #GtLlmChecker,
	#instVars : [
		'output'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmalltalkExecutionChecker >> check: aString [
	^ self execute: aString
]

{ #category : #accessing }
GtLlmSmalltalkExecutionChecker >> createStackString: anError [
	| errorStack thisStack |
	(anError isKindOf: SyntaxErrorNotification) ifTrue: [
		^ 'Syntax Error: ', anError messageText
	].
	errorStack := anError signalContext stack.
	thisStack := thisContext stack allButFirst: 9.
	errorStack := errorStack
			copyFrom: 1
			to: errorStack size - thisStack size.

	^ String
		streamContents: [ :stream | 
			errorStack
				do: [ :stackItem | 
					stream
						print: stackItem;
						cr ] ]
]

{ #category : #accessing }
GtLlmSmalltalkExecutionChecker >> execute: aString [
	[ ^ GtLlmCheckerSuccess new
		checker: self;
		content: (OpalCompiler new
				source: aString;
				receiver: self;
				evaluate) ]
		on: Exception
		do: [ :anError | 
			^ GtLlmCheckerError new
				checker: self;
				content: anError;
				contentString: (self createStackString: anError) ]
]

{ #category : #accessing }
GtLlmSmalltalkExecutionChecker >> name [
	^ 'Smalltalk Execution Checker'
]
