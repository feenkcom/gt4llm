Class {
	#name : #GtOpenAIResponseProvider,
	#superclass : #GtOpenAIProvider,
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> defaultAssistantMessageClass [
	^ GtOpenAIMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> defaultUserMessageClass [
	^ GtOpenAIMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIResponseProvider >> triggerAssistant [
	| result |
	self chat signalRunHasStarted.

	result := client
			generateResponseWithModel: self model
			andMessages: self chat messages.

	self chat
		addMessage: (self assistantMessageClass new merge: result output first).

	self chat signalRunIsDone
]
