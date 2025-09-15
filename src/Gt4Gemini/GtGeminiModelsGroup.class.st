Class {
	#name : #GtGeminiModelsGroup,
	#superclass : #GtGeminiGroup,
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiModelsGroup class >> itemClass [
	^ GtGeminiModel
]

{ #category : #accessing }
GtGeminiModelsGroup class >> leJsonV4Name [

	^ #gtGeminiModelsGroup
]

{ #category : #'as yet unclassified' }
GtGeminiModelsGroup class >> property [
	^ 'models'
]

{ #category : #'as yet unclassified' }
GtGeminiModelsGroup >> gtViewModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items ];
		column: 'Name' text: #name;
		column: 'Display name' text: #displayName;
		column: 'Description' text: #description
]
