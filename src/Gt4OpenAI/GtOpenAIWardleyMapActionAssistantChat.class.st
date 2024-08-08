Class {
	#name : #GtOpenAIWardleyMapActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

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

{ #category : #accessing }
GtOpenAIWardleyMapActionAssistantChat >> onActionResult: aMessage [
	| data |
	self pipeline instance topic: aMessage topicCodeBlock.

	self pipeline instance proposeModel: aMessage mapModel.

	aMessage renamesCodeBlock
		ifNotEmpty: [ :aRename | 
			data := STONJSON fromString: aRename.
			data
				keysAndValuesDo: [ :name :options | self pipeline instance addRenameFor: name withOptions: options ] ].

	aMessage explanationCodeBlock
		ifNotEmpty: [ :anExplanation | 
			self
				announce: (GtLlmSpawnRequestAnnouncement new
						object: (GtLlmWardleyMapExplanation new explanation: anExplanation)) ]
]
