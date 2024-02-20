Class {
	#name : #GtLlmCheckerSuccess,
	#superclass : #GtLlmCheckerResult,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckerSuccess class >> prefix [
	^ 'Output of the last script: '
]

{ #category : #accessing }
GtLlmCheckerSuccess >> backgroundColor [
	^ BrGlamorousColors successBackgroundColor
]

{ #category : #accessing }
GtLlmCheckerSuccess >> contentString [
	^ (GtLlmInspectorSummarizer new summarize: self content) summaryString
]

{ #category : #accessing }
GtLlmCheckerSuccess >> foregroundColor [
	^ Color black
]

{ #category : #accessing }
GtLlmCheckerSuccess >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self checker checkName;
		nextPut: $)
]
