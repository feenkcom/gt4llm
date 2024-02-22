Class {
	#name : #GtOpenAIGtObjectChat,
	#superclass : #Object,
	#instVars : [
		'instance'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIGtObjectChat >> buildElement [
	| chat tutor |
	tutor := GtOpenAIGtTutor globalInstance.
	chat := GtOpenAIAssistantChat new
			assistant: tutor assistant;
			pipeline: (GtLlmContext defaultPipeline instance: self instance).

	chat
		sendMessage: 'The context of this conversation is the following object instance:

' , (GtLlmInspectorSummarizer new summarize: self instance) summaryString
				, '

Can you write me a potentially useful Phlow view to be added on the object instance?'.

	^ GtOpenAIAssistantChatElement new
		assistantChatViewModel: (GtOpenAIAssistantObjectChatViewModel new assistantChat: chat)
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance [
	^ instance
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance: anObject [
	instance := anObject
]
