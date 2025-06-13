Extension { #name : #GtOllamaProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOllamaProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]
