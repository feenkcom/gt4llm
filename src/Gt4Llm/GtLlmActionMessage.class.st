Class {
	#name : #GtLlmActionMessage,
	#superclass : #GtLlmChatMessage,
	#traits : 'TGtActionMessage',
	#classTraits : 'TGtActionMessage classTrait',
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmActionMessage class >> defaultRole [
	^ nil
]
