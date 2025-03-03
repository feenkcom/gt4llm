Extension { #name : #GtOllamaProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOllamaProvider >> gtModelFileFor: aView [
	<gtView>
	modelfile ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Modelfile';
		priority: 1;
		object: [ modelfile ];
		view: #gtContentFor:;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect modelfile'
			action: [ :aButton | aButton phlow spawnObject: modelfile ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOllamaProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]
