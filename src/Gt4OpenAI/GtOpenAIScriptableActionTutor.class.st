Class {
	#name : #GtOpenAIScriptableActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIScriptableActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIAssistantChat new
			assistant: self assistant;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]
