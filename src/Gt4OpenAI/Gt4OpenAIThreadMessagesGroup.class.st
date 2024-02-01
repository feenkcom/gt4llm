Class {
	#name : #Gt4OpenAIThreadMessagesGroup,
	#superclass : #Gt4OpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIThreadMessagesGroup class >> itemClass [
	^ Gt4OpenAIThreadMessage
]

{ #category : #accessing }
Gt4OpenAIThreadMessagesGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role' text: #role width: 60;
		column: 'Message' text: #contentText
]
