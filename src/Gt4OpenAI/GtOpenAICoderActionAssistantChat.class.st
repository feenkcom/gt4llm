Class {
	#name : #GtOpenAICoderActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> messages [
	<return: #GtOpenAIThreadMessagesGroup>
	| givenMessages |
	givenMessages := thread updateMessages.
	^ GtOpenAIThreadMessagesGroup
		withAll: (givenMessages
				collect: [ :aMessage | 
					(GtOpenAICoderActionThreadMessage from: aMessage serialize)
						pipeline: self pipeline;
						chat: self ])
]
