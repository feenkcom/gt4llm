Class {
	#name : #GtOpenAICoderActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> instructions [
	^ self assistant instructions
]

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

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> method: aMethod [
	self pipeline instance method: aMethod
]

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> pipeline: aPipeline [
	super pipeline: aPipeline.
	aPipeline instance chat: self.
]
