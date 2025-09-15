Class {
	#name : #GtOllamaRunningModelsGroup,
	#superclass : #GtLlmGroup,
	#instVars : [
		'client'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaRunningModelsGroup class >> from: aDict [
	^ self
		withAll: ((aDict at: 'models')
				collect: [ :aModelDict | GtOllamaRunningModel from: aModelDict ])
]

{ #category : #accessing }
GtOllamaRunningModelsGroup class >> leJsonV4Name [

	^ #gtOllamaRunningModelsGroup
]

{ #category : #accessing }
GtOllamaRunningModelsGroup >> client [
	^ client
]

{ #category : #accessing }
GtOllamaRunningModelsGroup >> client: anObject [
	client := anObject.
	
	self do: [ :anItem | anItem client: client ]
]

{ #category : #accessing }
GtOllamaRunningModelsGroup >> gtModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [self items];
		column: 'Name' text: #name;
		column: 'Model' text: #model;
		column: 'VRAM size' text: #sizeVram;
		column: 'Expires at' text: #expiresAt
]
