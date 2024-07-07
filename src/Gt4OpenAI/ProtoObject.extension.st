Extension { #name : #ProtoObject }

{ #category : #'*Gt4OpenAI' }
ProtoObject >> gtGptFor: aView [
	<gtView>
	| chatStencil |
	^ aView explicit
		title: 'GPT';
		priority: 500;
		stencil: [ chatStencil := GtOpenAIGtObjectChat new instance: self.
			chatStencil buildElement ];
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect chat'
			action: [ :aButton | aButton phlow spawnObject: chatStencil chat ]
]
