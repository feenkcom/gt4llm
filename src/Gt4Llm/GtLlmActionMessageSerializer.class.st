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
GtLlmActionMessageSerializer >> serialize: aCall [
	^ STONJSON
		toString: {'Action' -> aCall action.
				'Arguments' -> aCall arguments} asDictionary
]
