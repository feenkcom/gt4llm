Extension { #name : #GtLlmChat }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> asViewModel [
	^ GtLlmChatViewModel new assistantChat: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	self provider ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Chat';
		priority: 0;
		stencil: [ self asElement ];
		actionUpdateButton
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> gtWriteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Write';
		priority: 4;
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

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> whenReadyFuture [
	^ GtLlmChatReadyFuture new chat: self
]
