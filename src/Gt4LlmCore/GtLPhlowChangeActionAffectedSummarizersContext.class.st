Class {
	#name : #GtLPhlowChangeActionAffectedSummarizersContext,
	#superclass : #GtPhlowChangeActionContext,
	#instVars : [
		'newSummarizers'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #callbacks }
GtLPhlowChangeActionAffectedSummarizersContext class >> newSummarizers: anObject [ 
	^ self new 
			newSummarizers: anObject 
]

{ #category : #accessing }
GtLPhlowChangeActionAffectedSummarizersContext >> actionIdentifier [
	^ 'summarizers'
]

{ #category : #accessing }
GtLPhlowChangeActionAffectedSummarizersContext >> newRelevantSummarizers [
	^ self newSummarizers select: [ :each |
			each isRelevant ]
]

{ #category : #accessing }
GtLPhlowChangeActionAffectedSummarizersContext >> newSummarizers [
	^ newSummarizers
]

{ #category : #accessing }
GtLPhlowChangeActionAffectedSummarizersContext >> newSummarizers: anObject [
	newSummarizers := anObject
]
