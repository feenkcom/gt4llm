"
I expose one tool call and its current status in the conversation tree.
"
Class {
	#name : #GtLACPToolCallTreeNode,
	#superclass : #GtLACPConversationTreeNode,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPToolCallTreeNode >> kind [
 ^ 'Tool'
]

{ #category : #accessing }
GtLACPToolCallTreeNode >> label [
 ^ object shortDescription
]

{ #category : #accessing }
GtLACPToolCallTreeNode >> state [
 ^ object status
]
