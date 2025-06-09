Extension { #name : #Behavior }

{ #category : #'*Gt4Llm-GToolkit' }
Behavior >> gtActionChatFor: anAction [
	<gtClassAction>
	| chat |
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ anAction empty ].
	GtLlmConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].



	^ anAction button
		priority: 100;
		icon: BrGlamorousVectorIcons chat;
		tooltip: 'Chat about class';
		action: [ :aButton | 
			aButton phlow
				spawnObject: (chat ifNil: [ chat := GtLlmClassAssistant new chatOn: self ]) ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: chat ]
			mouseCursor: BlCopyCursor new
]
