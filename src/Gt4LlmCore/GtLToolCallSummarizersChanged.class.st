Class {
	#name : #GtLToolCallSummarizersChanged,
	#superclass : #Announcement,
	#instVars : [
		'summarizersRegistry',
		'newSummarizers'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLToolCallSummarizersChanged >> newSummarizers [
	^ newSummarizers
]

{ #category : #accessing }
GtLToolCallSummarizersChanged >> newSummarizers: aCollection [
	newSummarizers := aCollection
]

{ #category : #accessing }
GtLToolCallSummarizersChanged >> summarizersRegistry [
	^ summarizersRegistry
]

{ #category : #accessing }
GtLToolCallSummarizersChanged >> summarizersRegistry: aSummarizersRegistry [
	summarizersRegistry := aSummarizersRegistry
]
