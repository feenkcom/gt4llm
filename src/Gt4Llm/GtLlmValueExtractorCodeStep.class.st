Class {
	#name : #GtLlmValueExtractorCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmValueExtractorCodeStep class >> stepName [
	^ 'Association value extractor'
]

{ #category : #accessing }
GtLlmValueExtractorCodeStep >> runStep: aContext [
	aContext
		addResult: (GtLlmStepSuccess new
				checker: self;
				content: aContext lastResult code value)
]
