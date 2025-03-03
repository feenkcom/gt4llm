Extension { #name : #LeWardleyMapSnippetViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
LeWardleyMapSnippetViewModel >> gtActionInspectChatFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect chat';
		icon: BrGlamorousVectorIcons openAi;
		target: LeSnippetContextMenuActionTarget uniqueInstance;
		priority: 2;
		action: [ :aButton :aSnippetElement | aSnippetElement phlow spawnObject: self wardleyMapViewModel llm ]
]
