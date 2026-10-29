"
I render a user prompt with selectable styled text. A message view model creates and builds me.
"
Class {
	#name : #GtLACPUserMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #ui }
GtLACPUserMessageElement >> buildContent [
 self addChild: (self messageSection: #prompt
  header: [ :expander |
   (self textElementFor: self replyPreviewText)
    id: #'acp-user-preview'; vExact: 24; yourself ]
  content: [
   BrVerticalPane new hMatchParent; vFitContent;
    addChild: (self textElementFor: viewModel message text); yourself ])
]
