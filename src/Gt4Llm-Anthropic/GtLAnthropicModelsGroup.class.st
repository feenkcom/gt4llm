Class {
	#name : #GtLAnthropicModelsGroup,
	#superclass : #GtLAnthropicGroup,
	#category : #'Gt4Llm-Anthropic-Model'
}

{ #category : #'as yet unclassified' }
GtLAnthropicModelsGroup class >> itemClass [
	^ GtLAnthropicModel
]

{ #category : #accessing }
GtLAnthropicModelsGroup class >> leJsonV4Name [

	^ #gtLAnthropicModelsGroup
]

{ #category : #'as yet unclassified' }
GtLAnthropicModelsGroup >> gtViewModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items sorted: [:a :b | a createdAt > b createdAt ] ];
		column: 'ID' text: #id;
		column: 'Display name' text: #displayName;
		column: 'Created at' text: #createdAt
]
