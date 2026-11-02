"
I adapt one ACP object to a conversation-tree row. My subclasses define agent, message and tool-call rows, and selection exposes the underlying object.
"
Class {
	#name : #GtLACPConversationTreeNode,
	#superclass : #GtLACPObject,
	#instVars : [
		'object',
		'turn'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPConversationTreeNode >> childrenIn: aCache [
 ^ #()
]

{ #category : #accessing }
GtLACPConversationTreeNode >> directory [
 ^ ''
]

{ #category : #accessing }
GtLACPConversationTreeNode >> messageCount [
 ^ 0
]

{ #category : #accessing }
GtLACPConversationTreeNode >> object [
 ^ object
]

{ #category : #accessing }
GtLACPConversationTreeNode >> object: anObject [
 object := anObject
]

{ #category : #accessing }
GtLACPConversationTreeNode >> turn: aTurn [
 turn := aTurn
]
