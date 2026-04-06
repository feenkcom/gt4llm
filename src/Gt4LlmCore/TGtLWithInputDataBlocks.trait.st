Trait {
	#name : #TGtLWithInputDataBlocks,
	#instVars : [
		'contentDataBlock'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'private - serialization' }
TGtLWithInputDataBlocks >> computeContentBlockFromInputModels [
	^ self computeContentDataViewFromInputModels serializeToLlmPrimiteData
]

{ #category : #'private - serialization' }
TGtLWithInputDataBlocks >> computeContentDataViewFromInputModels [
	| dataView |
	
	dataView := GtLCompositeDataView new.
	self inputModels do: [ :anInputModel |
		dataView addDataView: ((anInputModel llmDataViewsFor: GtLDataView new)
			dataKey: anInputModel name) ].
	
	^ dataView
]

{ #category : #accessing }
TGtLWithInputDataBlocks >> contentDataBlock [
	^ contentDataBlock ifNil: [ self computeContentBlockFromInputModels ]
]

{ #category : #'private - serialization' }
TGtLWithInputDataBlocks >> gtViewContentDataViewFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Data View';
		priority: 43;
		object: [ self computeContentDataViewFromInputModels  ];
		view: #gtDataViewsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'View'
			tooltip: 'Inspect data view'
			action: [ :aButton |
				aButton phlow spawnObject:   self computeContentDataViewFromInputModels ]
]
