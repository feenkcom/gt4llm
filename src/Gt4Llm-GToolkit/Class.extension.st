Extension { #name : #Class }

{ #category : #'*Gt4Llm-GToolkit' }
Class >> gtCoderSidebarIndexLlmChatFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 20>
	| chat |
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ nil ].
	GtLlmConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ nil ].

	^ BrMenuActionItem new
		icon: BrGlamorousVectorIcons chat
			label: 'Chat about this class'
			preview: self name;
		action: [ :aButton | 
			aButton phlow
				spawnObject: (chat ifNil: [ chat := GtLlmClassAssistant new chatOn: self ]) ]
]
