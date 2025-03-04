Extension { #name : #GtLlmEmbeddingRegistry }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmEmbeddingRegistry >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ embeddings associations ];
		column: 'Input' text: [ :aPair | aPair value input ];
		column: 'Actions'
			stencil: [ :aPair | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					label: 'Remove';
					icon: BrGlamorousVectorIcons remove;
					action: [ :aButton | 
						embeddings removeKey: aPair key.
						aButton phlow fireUpdateWish ] ]
			width: 80;
		send: #value
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmEmbeddingRegistry class >> gtInstanceButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Inspect unique instance';
		priority: 10;
		icon: BrGlamorousVectorIcons playinspect;
		action: [ :aButton | aButton phlow spawnObject: self uniqueInstance]
]
