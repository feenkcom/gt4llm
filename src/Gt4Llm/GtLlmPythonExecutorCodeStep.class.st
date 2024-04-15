Class {
	#name : #GtLlmPythonExecutorCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmPythonExecutorCodeStep class >> stepName [
	^ 'Python Executor'
]

{ #category : #accessing }
GtLlmPythonExecutorCodeStep >> runStep: aContext [
	PBApplication
		do: [ :anApplication | 
			aContext
				addResult: (GtLlmStepSuccess new
						checker: self;
						content: (anApplication evaluateSourceSequence: aContext lastResult source)) ]
]
