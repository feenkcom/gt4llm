Class {
	#name : #GtOpenAIWardleyMapActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapActionAssistantChat >> ancestorOf: aMessage [
	| messages |
	messages := self messages.

	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = messages size ifTrue: [ ^ nil ] ifFalse: [ ^ messages at: index + 1 ] ] ].

	self error: 'Message not found'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionAssistantChat >> gtWardleyScriptFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Script';
		priority: 5;
		object: [ self pipeline instance ];
		view: #gtWardleyScriptFor:
]

{ #category : #accessing }
GtOpenAIWardleyMapActionAssistantChat >> initializeWardleyMapModel: aGtWardleyMapModel [
	self pipeline instance initializeWardleyMapModel: aGtWardleyMapModel
]

{ #category : #accessing }
GtOpenAIWardleyMapActionAssistantChat >> messages [
	<return: #GtOpenAIThreadMessagesGroup>
	| givenMessages |
	givenMessages := thread updateMessages.
	^ GtOpenAIThreadMessagesGroup
		withAll: (givenMessages
				collect: [ :aMessage | 
					(GtOpenAIWardleyMapActionThreadMessage from: aMessage serialize)
						pipeline: self pipeline;
						chat: self ])
]
