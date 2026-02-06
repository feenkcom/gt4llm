Class {
	#name : #GtLOpenAIModelsGroup,
	#superclass : #GtLOpenAIGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIModelsGroup class >> itemClass [
	^ GtLOpenAIModel
]

{ #category : #accessing }
GtLOpenAIModelsGroup >> gtViewModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items sorted: [:a :b | a created > b created ] ];
		column: 'ID' text: #id;
		column: 'Owned by' text: #ownedBy;
		column: 'Created on' text: #created
]

{ #category : #'as yet unclassified' }
GtLOpenAIModelsGroup >> requestResponse: requestResponse [
]
