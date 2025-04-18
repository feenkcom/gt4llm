Extension { #name : #ProtoObject }

{ #category : #'*Gt4Llm-GToolkit' }
ProtoObject >> gtActionChatFor: anAction [
	<gtAction>
	GtLlmFeatures usesCoder ifFalse: [ ^ anAction empty ].
	^ anAction button
		priority: 100;
		icon: BrGlamorousVectorIcons openAi;
		tooltip: 'Chat about object';
		action: [ :aButton | aButton phlow spawnObject: (GtLlmObjectTutor new chatOn: self) ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: (GtLlmObjectTutor new chatOn: self) ]
			mouseCursor: BlCopyCursor new
]
