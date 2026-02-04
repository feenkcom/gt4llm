Class {
	#name : #GtLOpenAIApiCompactionStrategy,
	#superclass : #GtLOpenAICompactionStrategy,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'api - compaction' }
GtLOpenAIApiCompactionStrategy >> executeCompaction [
	| inputMessage result outputMessage |
	inputMessage := self provider createAPICompactionMessage.
	
	result := self provider 
		executeNextMessage: inputMessage.
		
	outputMessage := self provider
		responseTypeForResult: result 
		fromInputMessage: inputMessage.
		
	outputMessage updateDataFromMessage: inputMessage.
	
	self provider chat 
		addAssistantMessage: outputMessage.
]
