Class {
	#name : #GtLlmCheckerSuccess,
	#superclass : #GtLlmCheckerResult,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckerSuccess class >> prefix [
	^ 'LAST SCRIPT OUTPUT: '
]

{ #category : #accessing }
GtLlmCheckerSuccess >> color [
	^ BrGlamorousColors successBackgroundColor
]

{ #category : #accessing }
GtLlmCheckerSuccess >> contentString [
	^ (GtLlmInspectorSummarizer new summarize: self content) summaryString
]
