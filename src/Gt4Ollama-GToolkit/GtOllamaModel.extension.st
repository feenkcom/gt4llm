Extension { #name : #GtOllamaModel }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaModel >> gtDeleteModelActionFor: anAction [
	<gtAction>
	^ anAction button
		label: 'Delete';
		icon: BrGlamorousVectorIcons cancel;
		action: [ :aButton | self client deleteModel: self name ]
]
