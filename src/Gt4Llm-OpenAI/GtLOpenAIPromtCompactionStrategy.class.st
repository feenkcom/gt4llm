Class {
	#name : #GtLOpenAIPromtCompactionStrategy,
	#superclass : #GtLOpenAICompactionStrategy,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIPromtCompactionStrategy >> executeCompaction [
	self provider sendAPICompactionMessage
]
