Class {
	#name : #GtLlmSmalltalkMethodParserChecker,
	#superclass : #GtLlmParserChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmalltalkMethodParserChecker class >> language [
	^ 'Smalltalk method'
]

{ #category : #chcking }
GtLlmSmalltalkMethodParserChecker >> check: aString [
	^ self parse: aString
]

{ #category : #parsing }
GtLlmSmalltalkMethodParserChecker >> parse: aString [
	[ ^ GtLlmCheckerStringSuccess new
		checker: self;
		content: (OpalCompiler new
				source: aString;
				receiver: self;
				parseMethod);
		contentString: 'Successfully parsed.' ]
		on: Exception
		do: [ :anError | 
			^ GtLlmCheckerError new
				checker: self;
				content: anError;
				contentString: anError messageText ]
]
