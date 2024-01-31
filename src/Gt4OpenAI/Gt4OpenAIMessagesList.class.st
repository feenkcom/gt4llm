Class {
	#name : #Gt4OpenAIMessagesList,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIMessagesList >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role' text: #role width: 60;
		column: 'Message' text: #content;
		actionUpdateButton
]
