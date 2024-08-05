Class {
	#name : #GtOpenAIViewActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIViewActionAssistantChat >> instructions [
	^ self assistant instructions
]

{ #category : #accessing }
GtOpenAIViewActionAssistantChat >> messages [
	<return: #GtOpenAIThreadMessagesGroup>
	| givenMessages |
	givenMessages := thread updateMessages.
	^ GtOpenAIThreadMessagesGroup
		withAll: (givenMessages
				collect: [ :aMessage | 
					(GtOpenAIViewActionThreadMessage from: aMessage serialize)
						pipeline: self pipeline;
						chat: self ])
]

{ #category : #accessing }
GtOpenAIViewActionAssistantChat >> object: aMethod [
	self pipeline instance object: aMethod
]

{ #category : #accessing }
GtOpenAIViewActionAssistantChat >> pipeline: aPipeline [
	super pipeline: aPipeline.
	aPipeline instance chat: self.
]
