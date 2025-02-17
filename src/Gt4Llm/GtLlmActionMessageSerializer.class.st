Class {
	#name : #GtLlmActionMessageSerializer,
	#superclass : #GtLlmMessageSerializer,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmActionMessageSerializer >> gtInstanceFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtLlmActionMessageSerializer >> serialize: aString [
	^ STONJSON toString: {'Action' -> aString} asDictionary
]
