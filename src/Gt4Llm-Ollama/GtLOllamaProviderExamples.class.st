Class {
	#name : #GtLOllamaProviderExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Ollama-Examples'
}

{ #category : #examples }
GtLOllamaProviderExamples >> assistantMessage [
	<gtExample>
	| message result |
	result := GtLOllamaClientMessage from: {
		'model' -> 'llama3.2'.
		'message' -> {
			'role' -> 'assistant'.
			'content' -> 'Hello'
		} asDictionary
	} asDictionary.
	message := GtLOllamaAssistantMessage new initializeFromResult: result.
	self assert: message isAssistantRole.
	self assert: message contentText = 'Hello'.
	^ message
]

{ #category : #examples }
GtLOllamaProviderExamples >> chatWithProvider [
	<gtExample>
	| chat |
	chat := GtLChat new.
	chat provider: GtLOllamaProvider default.
	self assert: chat provider class = GtLOllamaProvider.
	^ chat
]

{ #category : #examples }
GtLOllamaProviderExamples >> userMessage [
	<gtExample>
	| chat message |
	chat := self chatWithProvider.
	message := chat createUserMessage.
	self assert: message isUserRole.
	self assert: message class = GtLOllamaUserMessage.
	^ message
]
