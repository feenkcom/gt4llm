Class {
	#name : #GtOpenAIBlogpostAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAIBlogpostAssistantChat >> messages [
	<return: #GtOpenAIThreadMessagesGroup>
	| givenMessages |
	givenMessages := thread updateMessages.
	^ GtOpenAIThreadMessagesGroup
		withAll: (givenMessages
				collect: [ :aMessage | 
					(GtOpenAIBlogPostAssistantThreadMessage from: aMessage serialize)
						pipeline: self pipeline;
						chat: self ])
]
