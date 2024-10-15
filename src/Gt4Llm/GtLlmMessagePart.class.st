Class {
	#name : #GtLlmMessagePart,
	#superclass : #Object,
	#category : #'Gt4Llm-Models'
}

{ #category : #'as yet unclassified' }
GtLlmMessagePart >> isString [
	^ false
]

{ #category : #'as yet unclassified' }
GtLlmMessagePart >> serialize [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLlmMessagePart >> serializeInline [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLlmMessagePart >> type [
	^ self subclassResponsibility
]
