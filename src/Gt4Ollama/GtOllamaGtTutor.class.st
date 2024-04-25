Class {
	#name : #GtOllamaGtTutor,
	#superclass : #GtLlmGtTutor,
	#category : #'Gt4Ollama-Tutor'
}

{ #category : #accessing }
GtOllamaGtTutor >> addChat [
	| aChat |
	aChat := GtOllamaChat new model: self model.
	aChat ensureModel.
	chats add: aChat.

	aChat addMessage: (GtLlmSystemMessage new content: self defaultInstructions).

	^ aChat
]

{ #category : #accessing }
GtOllamaGtTutor >> defaultModel [
	^ 'codellama'
]
