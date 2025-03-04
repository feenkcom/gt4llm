Extension { #name : #GtOllamaModelsGroup }

{ #category : #'*Gt4Ollama-GToolkit' }
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
