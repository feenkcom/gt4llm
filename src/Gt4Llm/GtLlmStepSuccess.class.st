Class {
	#name : #GtLlmStepSuccess,
	#superclass : #GtLlmStepResult,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmStepSuccess class >> prefix [
	^ 'Output of the last script: '
]

{ #category : #accessing }
GtLlmStepSuccess >> backgroundColor [
	^ BrGlamorousColors successBackgroundColor
]

{ #category : #accessing }
GtLlmStepSuccess >> contentString [
	^ (GtLlmInspectorSummarizer new summarize: self content) summaryString
]

{ #category : #accessing }
GtLlmStepSuccess >> foregroundColor [
	^ Color black
]

{ #category : #accessing }
GtLlmStepSuccess >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self checker class stepName;
		nextPut: $)
]
