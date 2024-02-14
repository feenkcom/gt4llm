Class {
	#name : #GtLlmPythonExecutorChecker,
	#superclass : #GtLlmExecutorChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmPythonExecutorChecker class >> language [
	^ 'Python'
]

{ #category : #accessing }
GtLlmPythonExecutorChecker >> errorToCatch [
	^ LanguageLinkError
]

{ #category : #accessing }
GtLlmPythonExecutorChecker >> execute: aString [
	^ PBApplication
		do: [ :application | 
			application newCommandStringFactory
				resultExpression: aString;
				sendAndWait ]
]

{ #category : #accessing }
GtLlmPythonExecutorChecker >> handlError: anError [
	^ GtLlmCheckerError new
		checker: self;
		content: anError;
		contentString: anError messageText
]
