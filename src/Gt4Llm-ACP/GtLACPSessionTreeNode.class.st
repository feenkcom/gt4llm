"
I expose an agent session, its nested sessions and its own messages and tool calls in a conversation tree.
"
Class {
	#name : #GtLACPSessionTreeNode,
	#superclass : #GtLACPConversationTreeNode,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPSessionTreeNode >> childrenIn: aCache [
 ^ (object childSessions collect: [ :session |
   aCache at: session ifAbsentPut: [ session asConversationTreeNode ] ]),
  (object turns copy flatCollect: [ :aTurn |
   aTurn conversationTreeItems collect: [ :item |
    aCache at: item ifAbsentPut: [ item asConversationTreeNode turn: aTurn; yourself ] ] ])
]

{ #category : #accessing }
GtLACPSessionTreeNode >> directory [
 ^ object directory ifNil: [ '' ] ifNotNil: #fullName
]

{ #category : #accessing }
GtLACPSessionTreeNode >> kind [
 ^ 'Agent'
]

{ #category : #accessing }
GtLACPSessionTreeNode >> label [
 ^ object conversationTitle
]

{ #category : #accessing }
GtLACPSessionTreeNode >> messageCount [
 ^ object turns sum: [ :each | each messages size ]
]

{ #category : #accessing }
GtLACPSessionTreeNode >> state [
 ^ object conversationState
]
