Class {
	#name : #GtLlmChatsGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmChatsGroup >> gtChatsFor: aView [
	<aView>
	^ aView columnedList
		title: 'Chats';
		priority: 1;
		items: [ self items ];
		column: 'Last updated' text: [ :aChat | aChat lastUpdate ];
		column: 'Messages' text: [ :aChat | aChat messages size ] weight: 0.5
]
