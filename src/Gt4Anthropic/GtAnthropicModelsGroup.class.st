Class {
	#name : #GtAnthropicModelsGroup,
	#superclass : #GtAnthropicGroup,
	#category : #Gt4Anthropic
}

{ #category : #'as yet unclassified' }
GtAnthropicModelsGroup class >> itemClass [
	^ GtAnthropicModel
]

{ #category : #accessing }
GtAnthropicModelsGroup class >> leJsonV4Name [

	^ #gtAnthropicModelsGroup
]

{ #category : #'as yet unclassified' }
GtAnthropicModelsGroup >> gtViewModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items sorted: [:a :b | a createdAt > b createdAt ] ];
		column: 'ID' text: #id;
		column: 'Display name' text: #displayName;
		column: 'Created at' text: #createdAt
]
