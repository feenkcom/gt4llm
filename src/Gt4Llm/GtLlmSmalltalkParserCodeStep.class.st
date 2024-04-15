Class {
	#name : #GtLlmSmalltalkParserCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmSmalltalkParserCodeStep class >> stepName [
	^ 'Smalltalk Parser'
]

{ #category : #accessing }
GtLlmSmalltalkParserCodeStep >> runStep: aContext [
	[ aContext
		addResult: (GtLlmStepSuccess new
				checker: self;
				content: (OpalCompiler new
						source: aContext lastResult code source;
						receiver: self;
						parseDoIt)) ]
		on: Exception
		do: [ :anError | 
			aContext
				addResult: (GtLlmStepError new
						checker: self;
						content: anError;
						contentString: anError messageText) ]
]
