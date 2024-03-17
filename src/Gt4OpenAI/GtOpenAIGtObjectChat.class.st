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
	tutor := GtOpenAIGtTutor instance.
	tutor hasAssistant ifFalse: [ tutor createAssistant ].

	chat := GtOpenAIAssistantChat new
			assistant: tutor assistant;
			pipeline: (GtLlmContext defaultSmalltalkChecker immutableInstance instance: self instance).

	chat
		sendMessage: 'The context of this conversation is the following object instance:

' , (GtLlmInspectorSummarizer new summarize: self instance) summaryString
				, '

Please provide me with a potentially useful Phlow view method for the object instance. Strictly adhere to the Phlow API you know.'.

	^ GtOpenAIAssistantChatElement new
		assistantChatViewModel: (GtOpenAIAssistantChatViewModel new assistantChat: chat)
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance [
	^ instance
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance: anObject [
	instance := anObject
]
