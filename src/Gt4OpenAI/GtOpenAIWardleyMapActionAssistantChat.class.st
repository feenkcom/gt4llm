Class {
	#name : #GtOpenAIWardleyMapActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionAssistantChat >> gtWardleyScriptFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Wardley map script';
		priority: 5;
		object: [ self pipeline instance ];
		view: #gtWardleyScriptFor:
]

{ #category : #accessing }
GtOpenAIWardleyMapActionAssistantChat >> initializeWardleyMapModel: aGtWardleyMapModel [
	self pipeline instance initializeWardleyMapModel: aGtWardleyMapModel
]

{ #category : #'as yet unclassified' }
GtOpenAIWardleyMapActionAssistantChat >> messageClass [
	^ GtOpenAIWardleyMapActionThreadMessage
]
