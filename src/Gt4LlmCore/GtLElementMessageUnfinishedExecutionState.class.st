Class {
	#name : #GtLElementMessageUnfinishedExecutionState,
	#superclass : #BlElementUniqueState,
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #printing }
GtLElementMessageUnfinishedExecutionState >> gtDisplayOn: aStream [
	aStream nextPutAll: 'LLM message unfinished execution state'
]

{ #category : #accessing }
GtLElementMessageUnfinishedExecutionState >> priority [
	^ UserPriority
]

{ #category : #accessing }
GtLElementMessageUnfinishedExecutionState >> type [
	"Return an object used to compare two states when adding to the collection of states in order to prevent
	elements from having duplicated states"
	<return: #Object>

	^ self
]
