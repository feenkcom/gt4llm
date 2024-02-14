Class {
	#name : #GtOpenAIThreadMessagesGroup,
	#superclass : #GtOpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIThreadMessagesGroup class >> itemClass [
	^ GtOpenAIThreadMessage
]

{ #category : #accessing }
GtOpenAIThreadMessagesGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role' text: #role width: 60;
		column: 'Message' text: #contentText
]
