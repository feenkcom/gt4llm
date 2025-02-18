Class {
	#name : #GtLlmActionMessage,
	#superclass : #GtLlmChatMessage,
	#traits : 'TGtActionMessage',
	#classTraits : 'TGtActionMessage classTrait',
	#category : #'Gt4Llm-Models'
}

{ #category : #'as yet unclassified' }
GtLlmActionMessage class >> defaultRole [
	^ nil
]
