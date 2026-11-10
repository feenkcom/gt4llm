"
I expose one prompt turn, its state and its ordered messages and tool calls in a conversation tree. Selecting me exposes the underlying prompt turn.
"
Class {
	#name : #GtLACPTurnTreeNode,
	#superclass : #GtLACPConversationTreeNode,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPTurnTreeNode >> childrenIn: aCache [
	^ object conversationTreeItems
		collect: [ :item | 
			aCache
				at: item
				ifAbsentPut: [ item asConversationTreeNode
						turn: object;
						yourself ] ]
]

{ #category : #accessing }
GtLACPTurnTreeNode >> kind [
	^ 'Turn'
]

{ #category : #accessing }
GtLACPTurnTreeNode >> label [
	| title text |
	title := 'Turn ' , (object session turns indexOf: object) asString.
	object inputMessages ifEmpty: [ ^ title ].
	text := (object inputMessages first text copyReplaceAll: String cr with: ' ')
			copyReplaceAll: String lf
			with: ' '.
	text ifEmpty: [ ^ title ].
	text size > 120 ifTrue: [ text := (text first: 119) , '…' ].
	^ title , ': ' , text
]

{ #category : #accessing }
GtLACPTurnTreeNode >> messageCount [
	^ object messages size
]

{ #category : #accessing }
GtLACPTurnTreeNode >> state [
	^ object stateName
]
