Class {
	#name : #GtLApiCompactionStrategy,
	#superclass : #GtLCompactionStrategy,
	#category : 'Gt4LlmCore-Compaction'
}

{ #category : #'api - compaction' }
GtLApiCompactionStrategy >> executeCompaction [
	| inputMessage result outputMessage |
	inputMessage := self provider createAPICompactionMessage.
	
	result := self provider 
		executeNextMessage: inputMessage.
		
	outputMessage := self provider
		responseTypeForResult: result 
		fromInputMessage: inputMessage.
	outputMessage updateDataFromMessage: inputMessage.
	
	self provider chat 
		addCompactionMessage: outputMessage.
]
