Class {
	#name : #GtLlmSmaCCParserChecker,
	#superclass : #GtLlmParserChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmaCCParserChecker class >> parserClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmSmaCCParserChecker >> parse: aString [
	[ ^ GtLlmCheckerStringSuccess new
		checker: self;
		content: (self class parserClass parse: aString);
		contentString: 'Successfully parsed.' ]
		on: SmaCCParserError
		do: [ :anError | 
			^ GtLlmCheckerError new
				checker: self;
				content: anError;
				contentString: anError messageText ]
]
