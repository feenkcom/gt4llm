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
	| result |
	[ OpalCompiler new
		source: aString;
		receiver: self;
		evaluate ]
		on: Error
		do: [ :anError | 
			self resetOutput.
			^ Gt4OpenAIExecutionError new content: (self createStackString: anError) ].

	result := self output contents.

	self resetOutput.

	^ Gt4OpenAIExecutionSuccess new content: result asString
]

{ #category : #accessing }
Gt4OpenAIExecutor >> output [
	^ output
]

{ #category : #accessing }
Gt4OpenAIExecutor >> output: anObject [ 
	output := anObject
]

{ #category : #accessing }
Gt4OpenAIExecutor >> resetOutput [
	self output: BlTextStream new
]
