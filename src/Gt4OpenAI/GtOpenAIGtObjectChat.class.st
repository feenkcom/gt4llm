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
	tutor := GtOpenAIGtSpecificTutor instance.
	tutor hasAssistant ifFalse: [ tutor createAssistant ].

	chat := GtOpenAIAssistantChat new
			assistant: tutor assistant;
			pipeline: (GtLlmContext defaultPipeline immutableInstance instance: self instance).

	chat sendMessage: self initialMessage.

	^ GtLlmChatElement new
		assistantChatViewModel: (GtLlmChatViewModel new assistantChat: chat)
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> initialMessage [
	^ 'The context of this conversation is ' , (GtLlmInspectorSummarizer new summarize: self instance) summaryString
		, String cr, String cr, 'Please provide me with a potentially useful Phlow view method for the object instance. Strictly adhere to the Phlow API you know.'
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance [
	^ instance
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance: anObject [
	instance := anObject
]
