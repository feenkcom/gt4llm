Extension { #name : #LeWardleyMapSnippetViewModel }

{ #category : #'*Gt4Llm' }
LeWardleyMapSnippetViewModel >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	self hasSnippetModel ifNil: [ ^ aView empty ].

	^ self snippetModel gtMessagesWidgetFor: aView
]
