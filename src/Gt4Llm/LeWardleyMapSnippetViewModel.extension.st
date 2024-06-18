Extension { #name : #LeWardleyMapSnippetViewModel }

{ #category : #'*Gt4Llm' }
LeWardleyMapSnippetViewModel >> gtActionInspectChatFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect OpenAI chat';
		icon: BrGlamorousVectorIcons playinspect;
		target: LeSnippetContextMenuActionTarget uniqueInstance;
		priority: 10;
		action: [ :aButton :aSnippetElement | 
			aSnippetElement phlow
				spawnObject: aSnippetElement wardleyMapViewModel openAITutorChat ]
]
