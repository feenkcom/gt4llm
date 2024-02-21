Class {
	#name : #GtLlmSmalltalkMethodParserChecker,
	#superclass : #GtLlmParserChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmalltalkMethodParserChecker class >> language [
	^ 'Smalltalk-method'
]

{ #category : #parsing }
GtLlmSmalltalkMethodParserChecker >> parse: aString [
	| aMethod |
	aMethod := GtLlmMethodSource forSource: aString.

	aMethod methodClass
		ifNil: [ ^ GtLlmCheckerStringError new
				checker: self;
				contentString: ('{1} class does not exist' format: {aMethod methodClassName}) ].

	[ ^ GtLlmCheckerStringSuccess new
		checker: self;
		content: (RBParser parseMethod: aMethod methodSource);
		contentString: 'Successfully parsed.' ]
		on: Exception
		do: [ :anError | 
			^ GtLlmCheckerError new
				checker: self;
				content: anError;
				contentString: anError messageText ]
]
