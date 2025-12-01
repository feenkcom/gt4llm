Class {
	#name : #GtLOpenAIStepsGroup,
	#superclass : #GtLOpenAIGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIStepsGroup >> gtStepsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Steps';
		priority: 1;
		items: [self items ];
		column: 'Name' text: #name weight: 0.5;
		column: 'Description' text: #description;
		column: 'Rules' text: #rules
]
