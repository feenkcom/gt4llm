Extension { #name : #GtLlmActionChat }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmActionChat >> asViewModel [
	^ GtLlmActionChatViewModel new assistantChat: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmActionChat >> executeWait: aBlock [
	(self whenReadyFuture then: [ :_ | aBlock value: self messages last ]) await
]
