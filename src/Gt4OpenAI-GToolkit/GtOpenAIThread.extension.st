Extension { #name : #GtOpenAIThread }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIThread >> gtMessagesFor: aView [
	<gtView>
	^ aView forward
		title: 'Messages';
		priority: 1;
		object: [ self messages ];
		view: #gtMessagesFor:;
		actionButtonIcon: BrGlamorousVectorIcons refresh
			tooltip: 'Update'
			action: [ :aButton :aTab | 
				self updateMessages.
				aTab viewContentElement phlow update ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIThread >> gtWriteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Write';
		priority: 2;
		text: [ 'Write a message here' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Send'
			action: [ :aButton | 
				aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | 
						self sendMessage: anEditor text asString.
						anEditor text: '' ] ]
]
