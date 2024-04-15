Class {
	#name : #GtLlmSmalltalkExecutorCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmSmalltalkExecutorCodeStep class >> stepName [
	^ 'Smalltalk Executor'
]

{ #category : #accessing }
GtLlmSmalltalkExecutorCodeStep >> runStep: aContext [
	aContext
		addResult: ([ GtLlmStepSuccess new
				checker: self;
				content: (OpalCompiler new
						source: aContext lastResult source;
						receiver: self;
						evaluate) ]
				on: Error
				do: [ :anError | 
					GtLlmStepError new
						checker: self;
						content: anError;
						contentString: anError messageText ])
]
