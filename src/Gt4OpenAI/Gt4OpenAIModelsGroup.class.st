Class {
	#name : #Gt4OpenAIModelsGroup,
	#superclass : #Gt4OpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIModelsGroup class >> itemClass [
	^ Gt4OpenAIModel
]

{ #category : #accessing }
Gt4OpenAIModelsGroup >> gtViewModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items ];
		column: 'ID' text: #id;
		column: 'Owned by' text: #ownedBy;
		column: 'Created on' text: #created
]
