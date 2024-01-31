Class {
	#name : #Gt4OpenAIModelsList,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIModelsList class >> from: aList [
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | Gt4OpenAIModel from: aModel ])
]

{ #category : #accessing }
Gt4OpenAIModelsList >> gtViewModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items ];
		column: 'ID' text: #id;
		column: 'Owned by' text: #ownedBy;
		column: 'Created on' text: #created
]
