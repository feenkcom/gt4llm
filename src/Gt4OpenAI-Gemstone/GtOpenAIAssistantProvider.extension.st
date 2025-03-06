Extension { #name : #GtOpenAIAssistantProvider }

{ #category : #'*Gt4OpenAI-Gemstone' }
GtOpenAIAssistantProvider >> executeWait [
	[ self getRun isDone ] whileFalse: [ 5 seconds wait ].

	self updateMessages.
	chat signalRunIsDone
]

{ #category : #'*Gt4OpenAI-Gemstone' }
GtOpenAIAssistantProvider >> registerForFinalization [
]
