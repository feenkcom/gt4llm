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
				content: (GtPharoParser
						parse: aContext lastResult code source
						startingAt: GtPharoParser startingStateForMethodSequence)) ]
		on: Exception
		do: [ :anError | 
			aContext
				addResult: (GtLlmStepError new
						checker: self;
						content: anError;
						contentString: anError messageText) ]
]
