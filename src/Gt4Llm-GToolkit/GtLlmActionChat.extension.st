Extension { #name : #GtLlmActionChat }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmActionChat >> asViewModel [
	^ GtLlmActionChatViewModel new assistantChat: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmActionChat >> executeWait: aBlock [
	(self whenReadyFuture then: [ :_ | aBlock value: self messages last ]) await
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmActionChat >> gtAssistantInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Assistant instruction';
		object: [ assistant ];
		view: #gtInstructionFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect action: [ :b | b phlow spawnObject: assistant ]
]
