Extension { #name : #Class }

{ #category : #'*Gt4Llm-GToolkit' }
Class >> gtCoderSidebarIndexLlmChatFor: anAction [
	<gtAction>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ anAction noAction ].
	GtLlmConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction noAction ].

	^ anAction button
		priority: 20;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons chat;
		label: ('Chat about this {1}' format: {self gtCoderTypeName});
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration default;
		action: [ :aButton | 
			aButton phlow
				spawnObject: (GtLlmAssistantLibraryForGt gtChat
						onInstance: (GtLlmAssistantLibraryForGt valueHolderForClass: self instanceSide))	"GtLlmClassAssistant new chatOn: self instanceSide" ]
]
