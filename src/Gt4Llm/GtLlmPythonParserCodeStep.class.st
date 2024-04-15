Class {
	#name : #GtLlmPythonParserCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmPythonParserCodeStep class >> stepName [
	^ 'Python Parser'
]

{ #category : #accessing }
GtLlmPythonParserCodeStep >> runStep: aContext [
	aContext
		addResult: (GtLlmStepSuccess new
				checker: self;
				content: (PythonParser parse: aContext lastResult code source))
]
