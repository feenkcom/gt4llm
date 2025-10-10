Extension { #name : #ProtoObject }

{ #category : #'*Gt4Llm-GToolkit' }
ProtoObject >> gtActionChatFor: anAction [
	<gtAction>
	| chat |
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ anAction empty ].
	GtLlmConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].

	^ anAction button
		priority: 100;
		icon: BrGlamorousVectorIcons chat;
		tooltip: 'Chat about object';
		action: [ :aButton | 
			aButton phlow
				spawnObject: (
				"(GtLlmAssistantLibraryForGt gtChat
						onInstance: (GtLlmAssistantLibraryForGt valueHolderForObject: self))"
				chat ifNil: [ chat := GtLlmObjectAssistant new chatOn: self ]) ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: chat ]
			mouseCursor: BlCopyCursor new
]
