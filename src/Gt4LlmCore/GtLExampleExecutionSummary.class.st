Class {
	#name : #GtLExampleExecutionSummary,
	#superclass : #Object,
	#instVars : [
		'successes',
		'failures',
		'errors',
		'skipped',
		'result'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> errorCount [
	^ errors size
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> errors: aCollection [ 
	errors := aCollection
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> failureCount [
	^ failures size
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> failures: aCollection [ 
	failures := aCollection
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> result [
	^ result
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> result: anObject [ 
	result := anObject
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> skipped: aCollection [ 
	skipped := aCollection
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> skippedCount [
	^ skipped size
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> successCount [
	^ successes size
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> successes: aCollection [ 
	successes := aCollection
]

{ #category : #'as yet unclassified' }
GtLExampleExecutionSummary >> totalCount [
	^ successes size + failures size + skipped size + errors size
]
