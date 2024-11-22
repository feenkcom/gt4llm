Class {
	#name : #GtDPostMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4Llm-Demo'
}

{ #category : #view }
GtDPostMessage >> gtDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	(self contentJson includesKey: 'Post') ifFalse: [ ^ aView empty ].
	^ aView diff
		title: 'Diff';
		from: [ self chat instance value text asString ];
		to: [ self contentJson at: 'Post' ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			action: [ :b | self chat instance updateContent: (self contentJson at: 'Post') ]
]
