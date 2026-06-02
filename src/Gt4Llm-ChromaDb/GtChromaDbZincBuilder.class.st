Class {
	#name : #GtChromaDbZincBuilder,
	#superclass : #Object,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #'instance creation' }
GtChromaDbZincBuilder >> create [
	"Create a new Zinc client to communicate with OpenAI server"

	| aClient |
	aClient := self newBasicClient.
	aClient forJsonREST.
	aClient timeout: 1200.
	^ aClient
]

{ #category : #private }
GtChromaDbZincBuilder >> newBasicClient [
	^ ZnClient new
]
