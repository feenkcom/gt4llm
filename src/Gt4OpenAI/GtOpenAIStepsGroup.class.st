Class {
	#name : #GtOpenAIStepsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIStepsGroup >> gtStepsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Steps';
		priority: 1;
		items: [self items ];
		column: 'Name' text: #name weight: 0.5;
		column: 'Description' text: #description;
		column: 'Rules' text: #rules
]
