Class {
	#name : #Gt4OpenAIExecutionSuccess,
	#superclass : #Gt4OpenAIExecutionResult,
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #accessing }
Gt4OpenAIExecutionSuccess class >> prefix [
	^ 'LAST SCRIPT OUTPUT: '
]

{ #category : #accessing }
Gt4OpenAIExecutionSuccess >> contentString [
	^ (GtLlmInspectorSummarizer new summarize: self content) summaryString
]
