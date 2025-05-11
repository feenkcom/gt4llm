Class {
	#name : #GtLlmNullConnection,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmNullConnection >> buildProvider [
	^ GtLlmNullProvider new
]
