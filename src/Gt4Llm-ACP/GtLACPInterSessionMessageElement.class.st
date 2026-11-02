"
I render an incoming or unattributed agent-to-agent message with its routing label and styled content.
"
Class {
	#name : #GtLACPInterSessionMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPInterSessionMessageElement >> buildContent [
 self addChild: (self textElementFor: viewModel message text)
]
