Class {
	#name : #GtLOllamaOpenAiAssistantMessage,
	#superclass : #GtLOllamaAssistantMessage,
	#category : 'Gt4Llm-Ollama-Model'
}

{ #category : #'as yet unclassified' }
GtLOllamaOpenAiAssistantMessage >> contentText [
	| choices |
	
	choices := self rawData at: 'choices'.
	choices ifNil: [ ^ '' ].
	self assert: choices size = 1.
	
	^ (choices first at: 'message') at: 'content'
]

{ #category : #'as yet unclassified' }
GtLOllamaOpenAiAssistantMessage >> thoughtText [
	| choices |
	
	choices := self rawData at: 'choices'.
	choices ifNil: [ ^ '' ].
	self assert: choices size = 1.
	
	^ (choices first at: 'message') at: 'reasoning' ifAbsent: [ '' ]
]
