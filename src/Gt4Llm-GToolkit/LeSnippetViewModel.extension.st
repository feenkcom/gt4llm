Extension { #name : #LeSnippetViewModel }

{ #category : #'*Gt4Llm-GToolkit' }
LeSnippetViewModel >> gtActionChatFor: anAction [
	<gtAction>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ anAction empty ].
	GtLlmConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].
	
	^ anAction button
		tooltip: 'Chat about the snippet';
		icon: BrGlamorousVectorIcons inspect;
		target: LeSnippetContextMenuActionTarget uniqueInstance;
		priority: 5;
		action: [ :aButton :aSnippetElement | 
			aSnippetElement phlow
				spawnObject: (GtLlmAssistantLibraryForGt gtChat
						onInstance: (GtLlmAssistantLibraryForGt
								valueHolderForPharoSnippet: aSnippetElement snippetViewModel)) ]
]
