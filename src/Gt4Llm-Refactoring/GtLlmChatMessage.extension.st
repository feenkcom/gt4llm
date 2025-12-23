Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4Llm-Refactoring' }
GtLlmChatMessage >> gtIsTransformationMessage [
	| json |
	json := self contentJson.
	^ (json includesKey: 'Pharo Transformations')
		and: [ (STONJSON fromString: (self contentJson at: 'Pharo Transformations')) notEmpty ]
]

{ #category : #'*Gt4Llm-Refactoring' }
GtLlmChatMessage >> gtTransformationChangesFor: aView [
	<gtView>
	<gtLlmMessageView>
	self isAssistantRole ifFalse: [ ^ aView empty ].
	self gtIsTransformationMessage ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Changes';
		priority: 5;
		object: [ self chat assistant
				applyTransformations: (STONJSON fromString: (self contentJson at: 'Pharo Transformations')) ];
		view: #gtChangesFor:
]

{ #category : #'*Gt4Llm-Refactoring' }
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
