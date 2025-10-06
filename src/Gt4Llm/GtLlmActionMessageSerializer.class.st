Class {
	#name : #GtLlmActionMessageSerializer,
	#superclass : #GtLlmMessageSerializer,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmActionMessageSerializer class >> leJsonV4Name [

	^ #gtLlmActionMessageSerializer
]

{ #category : #'as yet unclassified' }
GtLlmActionMessageSerializer >> serialize: aCall [
	| associations |
	associations := {'Action' -> aCall action.
			'Arguments' -> aCall arguments}.
	^ STONJSON toString: associations asDictionary
]
