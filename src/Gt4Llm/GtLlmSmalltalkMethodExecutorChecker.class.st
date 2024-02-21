Class {
	#name : #GtLlmSmalltalkMethodExecutorChecker,
	#superclass : #GtLlmExecutorChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmalltalkMethodExecutorChecker class >> language [
	^ 'Smalltalk-method'
]

{ #category : #private }
GtLlmSmalltalkMethodExecutorChecker >> createStackString: anError [
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
GtLlmSmalltalkMethodExecutorChecker >> errorToCatch [
	^ Error
]

{ #category : #execution }
GtLlmSmalltalkMethodExecutorChecker >> execute: aString [
	| aMethod anUpdater aResponse |
	aMethod := GtLlmMethodSource fromSource: aString.

	aMethod methodClass
		ifNil: [ ^ GtLlmCheckerStringError new
				checker: self;
				contentString: ('{1} class does not exist' format: {aMethod methodClassName}) ].

	anUpdater := GtLlmMethodSourceUpdater new methodSource: aMethod.
	aResponse := anUpdater update.
	^ GtLlmCheckerSuccess new
		checker: self;
		content: aResponse messageText
]

{ #category : #accessing }
GtLlmSmalltalkMethodExecutorChecker >> handlError: anError [
	^ GtLlmCheckerError new
		checker: self;
		content: anError;
		contentString: (self createStackString: anError)
]
