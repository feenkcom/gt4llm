Class {
	#name : #GtOpenAIMessagesGroup,
	#superclass : #GtOpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIMessagesGroup class >> itemClass [
	^ GtOpenAIChatMessage
]

{ #category : #accessing }
GtOpenAIMessagesGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role' text: #role width: 60;
		column: 'Message' text: #content
]
