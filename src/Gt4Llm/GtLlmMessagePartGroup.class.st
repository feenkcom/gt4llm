Class {
	#name : #GtLlmMessagePartGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-Groups'
}

{ #category : #'as yet unclassified' }
GtLlmMessagePartGroup >> serialize [
	^ self items collect: #serialize
]

{ #category : #'as yet unclassified' }
GtLlmMessagePartGroup >> serializeInline [
	^ self items collect: #serializeInline
]
