Class {
	#name : #Gt4OpenAIExecutor,
	#superclass : #Object,
	#instVars : [
		'output'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #accessing }
Gt4OpenAIExecutor >> createStackString: anError [
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
Gt4OpenAIExecutor >> execute: aString [	
	[ ^ Gt4OpenAIExecutionSuccess new
		content: (OpalCompiler new
				source: aString;
				receiver: self;
				evaluate) ]
		on: Exception
		do: [ :anError | 
			^ Gt4OpenAIExecutionError new
				content: anError;
				stackString: (self createStackString: anError) ]
]
