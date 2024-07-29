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
	client := anObject.
	
	self do: [ :anItem | anItem client: client ]
]

{ #category : #accessing }
GtOllamaModelsGroup >> gtModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items ];
		column: 'Name' text: #name;
		column: 'Model' text: #model;
		column: 'Modified at'
			text: #modifiedAt
			weight: 2;
		column: 'Actions'
			stencil: [ :aModel | 
				| aToolbar |
				aToolbar := BrToolbar new
						aptitude: (BrGlamorousToolbarAptitude new spacing: 5);
						fitContent;
						addItem: (BrButton new beTinySize
								aptitude: BrGlamorousButtonWithIconAptitude;
								icon: BrGlamorousVectorIcons inspect;
								label: 'Get model information';
								action: [ aToolbar phlow spawnObject: (self client getModelInformationFor: aModel name) ]);
						addItem: (BrButton new beTinySize
								aptitude: BrGlamorousButtonWithIconAptitude;
								icon: BrGlamorousVectorIcons cancel;
								label: 'Delete model';
								action: [ self client deleteModel: aModel name ]) ]
]
