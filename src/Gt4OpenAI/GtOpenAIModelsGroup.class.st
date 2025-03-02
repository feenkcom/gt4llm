Class {
	#name : #GtOpenAIModelsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIModelsGroup class >> itemClass [
	^ GtOpenAIModel
]

{ #category : #accessing }
GtOpenAIModelsGroup >> gtViewModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items sorted: [:a :b | a created > b created ] ];
		column: 'ID' text: #id;
		column: 'Owned by' text: #ownedBy;
		column: 'Created on' text: #created
]
