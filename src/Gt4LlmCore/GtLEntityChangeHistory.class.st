"
Abstract history of changes for a single entity.
"
Class {
	#name : #GtLEntityChangeHistory,
	#superclass : #Object,
	#instVars : [
		'changes'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLEntityChangeHistory >> addChange: aCodeChange [
	self changes add: aCodeChange
]

{ #category : #accessing }
GtLEntityChangeHistory >> changes [
	^ changes ifNil: [ changes := OrderedCollection new ]
]

{ #category : #accessing }
GtLEntityChangeHistory >> changes: aCollection [
	changes := aCollection
]

{ #category : #accessing }
GtLEntityChangeHistory >> gtViewChangeEditTime [ 
	^ self latestChange  gtViewChangeEditTime
]

{ #category : #accessing }
GtLEntityChangeHistory >> gtViewChangeHistoryChildren [
	^ self changes
]

{ #category : #accessing }
GtLEntityChangeHistory >> gtViewChangesCount [
	^ self changes size
]

{ #category : #accessing }
GtLEntityChangeHistory >> latestChange [
	^ self changes ifEmpty: [ nil ] ifNotEmpty: [ self changes last ]
]
