Extension { #name : #GtLlmConnection }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmConnection >> gtActionSpawnProviderFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons playinspect;
		label: 'Provider';
		priority: 10;
		action: [ :aButton | aButton phlow spawnObject: self buildProvider ]
]
