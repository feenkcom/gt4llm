Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4Llm-SmaCCDeprecated' }
GtLlmChatMessage >> gtIsSmaCCEditMessage [
	^ self contentJson includesKey: 'SmaCC Edits'
]

{ #category : #'*Gt4Llm-SmaCCDeprecated' }
GtLlmChatMessage >> gtSmaCCChangesDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	| changes |
	self isAssistantRole ifFalse: [ ^ aView empty ].
	self gtIsSmaCCEditMessage ifFalse: [ ^ aView empty ].
	changes := GtLlmSmaCCChanges fromMessage: self.

	^ aView forward
		title: 'Diff';
		priority: 5;
		object: [ changes ];
		view: #gtDiffFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect changes'
			action: [ :b | b phlow spawnObject: changes ]
]

{ #category : #'*Gt4Llm-SmaCCDeprecated' }
GtLlmChatMessage >> gtSmaCCChangesFor: aView [
	<gtView>
	<gtLlmMessageView>
	| changes |
	self isAssistantRole ifFalse: [ ^ aView empty ].
	self gtIsSmaCCEditMessage ifFalse: [ ^ aView empty ].
	changes := GtLlmSmaCCChanges fromMessage: self.

	^ aView forward
		title: 'Grammar';
		priority: 5;
		object: [ changes ];
		view: #gtGrammarFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect grammar'
			action: [ :b | b phlow spawnObject: changes newGrammar ]
]
