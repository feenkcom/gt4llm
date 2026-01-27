Class {
	#name : #GtLToolsGroup,
	#superclass : #GtLTools,
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'as yet unclassified' }
GtLToolsGroup class >> isDeprecated [
	^ true
]

{ #category : #'as yet unclassified' }
GtLToolsGroup >> items: aCollection [
	self removeAll.
	self addAll: aCollection
]
