Extension { #name : #LeWardleyMapSnippet }

{ #category : #'*Gt4Llm' }
LeWardleyMapSnippet >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	self wardleyMap ifNil: [ ^ aView empty ].

	^ self wardleyMap gtMessagesWidgetFor: aView
]
