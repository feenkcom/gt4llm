Class {
	#name : #GtLlmSmalltalkParserChecker,
	#superclass : #GtLlmParserChecker,
	#instVars : [
		'output'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmSmalltalkParserChecker class >> language [
	^ 'Smalltalk'
]

{ #category : #accessing }
GtLlmSmalltalkParserChecker >> check: aString [
	^ self parse: aString
]

{ #category : #accessing }
GtLlmSmalltalkParserChecker >> parse: aString [
	[ ^ GtLlmCheckerStringSuccess new
		checker: self;
		content: (OpalCompiler new
				source: aString;
				receiver: self;
				parseDoIt);
		contentString: 'Successfully parsed.' ]
		on: Exception
		do: [ :anError | 
			^ GtLlmCheckerError new
				checker: self;
				content: anError;
				contentString: anError messageText ]
]
