Class {
	#name : #GtLPromptCompactionStrategy,
	#superclass : #GtLCompactionStrategy,
	#category : #'Gt4LlmCore-Compaction'
}

{ #category : #'as yet unclassified' }
GtLPromptCompactionStrategy >> executeCompaction [
	| inputMessage result outputMessage |
	inputMessage := self provider createPromptCompactionMessage.
	
	result := self provider 
		executeNextPromtCompactionMessage: inputMessage.
	
	outputMessage := self provider
		responseTypeForResult: result 
		fromInputMessage: inputMessage.
	outputMessage updateDataFromMessage: inputMessage.
	
	self provider chat 
		addCompactionMessage: outputMessage.
]
