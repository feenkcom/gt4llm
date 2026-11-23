"
I represent a variable removed from a class.
"
Class {
	#name : #GtLVariableRemovalResult,
	#superclass : #GtLVariableChangeResult,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLVariableRemovalResult >> changeKindLabel [
	^ 'Removed'
]

{ #category : #views }
GtLVariableRemovalResult >> gtViewChangeIcon [
	^ self class removalIcon
]

{ #category : #testing }
GtLVariableRemovalResult >> isVariableRemovalResult [
	^ true
]
