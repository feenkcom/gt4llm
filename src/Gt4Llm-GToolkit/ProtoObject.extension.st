Extension { #name : #ProtoObject }

{ #category : #'*Gt4Llm-GToolkit' }
ProtoObject >> gtActionChatFor: anAction [
	<gtAction>
	| chat |
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ anAction empty ].
	GtLlmConnectionRegistry instance hasConnectableDefaultConnection ifFalse: [ ^ anAction empty  ].
	
	chat := GtLlmObjectAssistant new chatOn: self.

	^ anAction button
		priority: 100;
		icon: BrGlamorousVectorIcons openAi;
		tooltip: 'Chat about object';
		action: [ :aButton | aButton phlow spawnObject: chat ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: chat ]
			mouseCursor: BlCopyCursor new
]
