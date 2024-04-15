Class {
	#name : #GtLlmSmalltalkMethodParserCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmSmalltalkMethodParserCodeStep class >> stepName [
	  ^ 'Smalltalk method parser'
]

{ #category : #accessing }
GtLlmSmalltalkMethodParserCodeStep >> runStep: aContext [
	| aMethod |
	aMethod := GtLlmMethodSource forSource: aContext lastResult code source.

	aMethod methodClass
		ifNil: [ aContext
				addResult: (GtLlmStepStringError new
						checker: self;
						contentString: ('{1} class does not exist' format: {aMethod methodClassName})).
			^ self ].

	aContext
		addResult: ([ GtLlmStepSuccess new
				checker: self;
				content: aMethod parse ]
				on: Exception
				do: [ :anError | 
					GtLlmStepError new
						checker: self;
						content: anError;
						contentString: anError messageText ])
]
