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
	tutor := GtOpenAIGtTutor withApiKeyFromClipboard createAssistant.
	chat := GtOpenAIAssistantChat new
			assistant: tutor assistant;
			pipeline: (GtLlmContext defaultPipeline instance: self instance).
	chat
		sendMessage: tutor files toFileDescriptions
				, '
		
The context of this conversation is the following object instance:

'
				, (GtLlmInspectorSummarizer new summarize: self instance) summaryString.
	^ GtOpenAIAssistantChatElement new assistantChat: chat
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance [
	^ instance
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance: anObject [
	instance := anObject
]
