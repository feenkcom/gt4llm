Class {
	#name : #GtLlmActionChat,
	#superclass : #GtLlmChat,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmActionChat >> asViewModel [
	^ GtLlmActionChatViewModel new assistantChat: self
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> defaultSerializer [
	^ GtLlmActionMessageSerializer new
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> onInstance: anInstance [
	self
		serializer: (GtLlmActionMessageWithInstanceSerializer new instance: anInstance)
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> sendAction: anActionCall [
	self
		sendMessage: ((self tutor actionNamed: anActionCall action) format
				format: anActionCall arguments)
]

{ #category : #accessing }
GtLlmActionChat >> sendChatRequest: aString [
	self
		sendAssistantMessage: (GtLlmUserMessage new
				content: (self messageFromString: 'Chat request: ' , aString))
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> updateInstance: aValue [
	self serializer update: aValue
]
