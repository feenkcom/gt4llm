Class {
	#name : #GtOllamaGtTutor,
	#superclass : #GtLlmGtSpecificTutor,
	#category : #'Gt4Ollama-Tutor'
}

{ #category : #accessing }
GtOllamaGtTutor >> addChat [
	| aChat |
	aChat := GtOllamaChat new
			model: self model;
			context: pipelineBuilder value.
	chats add: aChat.

	aChat
		addMessage: (GtLlmSystemMessage new content: self instructions instructionString).

	^ aChat
]

{ #category : #accessing }
GtOllamaGtTutor >> defaultModel [
	^ 'codellama'
]
