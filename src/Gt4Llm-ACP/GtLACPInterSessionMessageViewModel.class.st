"
I adapt an inter-session message for its chat element.
"
Class {
	#name : #GtLACPInterSessionMessageViewModel,
	#superclass : #GtLACPChatMessageViewModel,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPInterSessionMessageViewModel >> chatElementClass [
	^ GtLACPInterSessionMessageElement
]
