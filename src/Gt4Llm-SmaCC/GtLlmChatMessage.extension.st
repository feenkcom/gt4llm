Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4Llm-SmaCC' }
GtLlmChatMessage >> gtIsSmaCCEditMessage [
	^ self contentJson includesKey: 'SmaCC Edits'
]

{ #category : #'*Gt4Llm-SmaCC' }
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

{ #category : #'*Gt4Llm-SmaCC' }
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

{ #category : #'*Gt4Llm-SmaCC' }
GtLlmChatMessage >> gtTransformationsFor: aView [
	<gtView>
	<gtLlmMessageView>
	self isAssistantRole ifFalse: [ ^ aView empty ].
	self gtIsTransformationMessage ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Transformations';
		priority: 5;
		object: [ self chat assistant
				applyTransformations: (STONJSON fromString: (self contentJson at: 'Pharo Transformations')) ];
		view: #gtApplyingChangesFor:
]
