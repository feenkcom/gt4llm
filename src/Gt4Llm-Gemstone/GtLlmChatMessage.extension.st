Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4Llm-Gemstone' }
GtLlmChatMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Content';
		priority: 5;
		text: [ self contentText ]
]

{ #category : #'*Gt4Llm-Gemstone' }
GtLlmChatMessage >> gtJsonFor: aView [
	<gtView>
	<gtLlmMessageView>
	[ self contentJson ] on: Error do: [ ^ aView empty ].

	^ (self contentJson gtItemsFor: aView)
		title: 'JSON data';
		priority: 4.5
]

{ #category : #'*Gt4Llm-Gemstone' }
GtLlmChatMessage class >> isAbstract [
	^ self name = #GtLlmChatMessage
]
