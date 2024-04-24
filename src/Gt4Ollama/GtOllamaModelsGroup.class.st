Class {
	#name : #GtOllamaModelsGroup,
	#superclass : #GtLlmGroup,
	#instVars : [
		'client'
	],
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaModelsGroup class >> from: aDict [
	^ self
		withAll: ((aDict at: 'models') collect: [ :aModelDict | GtOllamaModel from: aModelDict ])
]

{ #category : #accessing }
GtOllamaModelsGroup >> client [
	^ client
]

{ #category : #accessing }
GtOllamaModelsGroup >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtOllamaModelsGroup >> gtModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [self items];
		column: 'Name' text: #name;
		column: 'Model' text: #model;
		column: 'Modified at' text: #modifiedAt weight: 2
]
