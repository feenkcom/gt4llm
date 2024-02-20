Extension { #name : #ProtoObject }

{ #category : #'*Gt4OpenAI' }
ProtoObject >> gtGptFor: aView [
	<gtView>
	^ aView explicit
		title: 'GPT';
		priority: 500;
		stencil: [ GtOpenAIGtObjectChat new instance: self; buildElement ]
]
