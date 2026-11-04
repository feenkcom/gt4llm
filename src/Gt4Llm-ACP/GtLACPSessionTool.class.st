"
I specialize GtPhlowChatTool for an ACP session. GtLACPChatToolElement reuses the Phlow chat tool header, object-view tabs and embedded playground, with ACP-specific view collection and the ACP Chat label.
"
Class {
	#name : #GtLACPSessionTool,
	#superclass : #GtPhlowChatTool,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #converting }
GtLACPSessionTool >> asElementDo: aBlock [
 | element |
 element := GtLACPSessionToolElement new chat: self chat.
 ^ aBlock cull: element cull: self
]

{ #category : #accessing }
GtLACPSessionTool >> name [
 ^ 'ACP Chat'
]
