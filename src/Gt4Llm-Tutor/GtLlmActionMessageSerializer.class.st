Class {
	#name : #GtLlmActionMessageSerializer,
	#superclass : #GtLlmMessageSerializer,
	#category : #'Gt4Llm-Tutor-Serializers'
}

{ #category : #'as yet unclassified' }
GtLlmActionMessageSerializer >> serialize: aString [
	^ STONJSON toString: {'Action' -> aString} asDictionary
]
