Class {
	#name : #GtLlmMessagePartGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmMessagePartGroup class >> leJsonV4Name [

	^ #gtLlmMessagePartGroup
]

{ #category : #'as yet unclassified' }
GtLlmMessagePartGroup >> serialize [
	^ self items collect: #serialize
]

{ #category : #'as yet unclassified' }
GtLlmMessagePartGroup >> serializeInline [
	^ self items collect: #serializeInline
]
