"
I expose an agent session, its nested sessions and its chronologically ordered prompt turns in a conversation tree.
"
Class {
	#name : #GtLACPSessionTreeNode,
	#superclass : #GtLACPConversationTreeNode,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPSessionTreeNode >> childrenIn: aCache [
	^ (object childSessions
		collect: [ :session | aCache at: session ifAbsentPut: [ session asConversationTreeNode ] ])
		, (object turns copy
				collect: [ :aTurn | aCache at: aTurn ifAbsentPut: [ aTurn asConversationTreeNode ] ])
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
