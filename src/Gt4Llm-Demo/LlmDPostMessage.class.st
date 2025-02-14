Class {
	#name : #LlmDPostMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4Llm-Demo'
}

{ #category : #'as yet unclassified' }
LlmDPostMessage >> gtDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	(self contentJson includesKey: 'Post') ifFalse: [ ^ aView empty ].
	^ aView diff
		title: 'Diff';
		priority: 2;
		from: [ self chat serializer instance value asString ];
		to: [ self contentJson at: 'Post' ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			action: [ :b | self chat serializer instance updateContent: (self contentJson at: 'Post') ]
]
