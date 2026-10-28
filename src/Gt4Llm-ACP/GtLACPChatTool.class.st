"
I specialize GtPhlowChatTool for an ACP session. I reuse its tool identity, icon and inspector integration while rendering GtLACPChatElement instead of the GtLChat-specific tool element.
"
Class {
	#name : #GtLACPChatTool,
	#superclass : #GtPhlowChatTool,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #converting }
GtLACPChatTool >> asElementDo: aBlock [
 ^ aBlock cull: self chat asElement cull: self
]

{ #category : #accessing }
GtLACPChatTool >> name [
 ^ 'ACP chat'
]
