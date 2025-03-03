Extension { #name : #GtOpenAIThreadRun }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIThreadRun >> gtActionReloadFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons refresh;
		tooltip: 'Reload';
		priority: 5;
		action: [ :aButton | aButton phlow spawnObject: (self client getRun: self id forThread: self threadId) ]
]
