Class {
	#name : #GtLOpenAIPromptCompactionStrategy,
	#superclass : #GtLOpenAICompactionStrategy,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIPromptCompactionStrategy >> executeCompaction [
	| inputMessage result outputMessage |
	inputMessage := self provider sendPromptCompactionMessage.
	
	result := self provider 
		executeNextMessage: inputMessage.
		
	outputMessage := self provider
		responseTypeForResult: result 
		fromInputMessage: inputMessage.
	outputMessage updateDataFromMessage: inputMessage.
	
	self provider chat 
		addCompactionMessage: outputMessage.
]
