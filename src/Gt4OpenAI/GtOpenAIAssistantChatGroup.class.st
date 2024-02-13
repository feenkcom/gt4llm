Class {
	#name : #GtOpenAIAssistantChatGroup,
	#superclass : #Gt4OpenAIGroup,
	#category : #'Gt4OpenAI-Groups'
}

{ #category : #accessing }
GtOpenAIAssistantChatGroup >> gtChatsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Chats';
		priority: 1;
		items: [ self items ];
		column: 'Assistant' text: [ :aChat | aChat assistant id ];
		column: 'Messages' text: [ :aChat | aChat messages size ];
		column: 'Last updated' text: [ :aChat | aChat lastUpdate ifNil: [ '' ] ]
]
