Class {
	#name : #GtLlmSmalltalkMethodExecutorCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmSmalltalkMethodExecutorCodeStep class >> stepName [
	^ 'Smalltalk method executor'
]

{ #category : #accessing }
GtLlmSmalltalkMethodExecutorCodeStep >> runStep: aContext [
	| aMethod anUpdater aResponse |
	aMethod := aContext lastResult.

	anUpdater := GtLlmMethodSourceUpdater new methodSource: aMethod.
	aResponse := anUpdater update.
	aContext
		addResult: (GtLlmStepSuccess new
				checker: self;
				content: aResponse messageText)
]
