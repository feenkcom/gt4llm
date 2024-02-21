Class {
	#name : #GtLlmSmalltalkExecutionChecker,
	#superclass : #GtLlmExecutorChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmalltalkExecutionChecker class >> language [
	^ 'Smalltalk'
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
GtLlmSmalltalkExecutionChecker >> errorToCatch [
	^ Error
]

{ #category : #accessing }
GtLlmSmalltalkExecutionChecker >> execute: aString [
	^ OpalCompiler new
		source: aString;
		receiver: self;
		evaluate
]

{ #category : #accessing }
GtLlmSmalltalkExecutionChecker >> handleError: anError [
	^ GtLlmCheckerError new
		checker: self;
		content: anError;
		contentString: (self createStackString: anError)
]
