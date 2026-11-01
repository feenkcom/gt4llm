"
I am the stable one-pixel final item of an ACP chat list. I give Brick a logical scrolling target below even the tallest message without becoming a conversation message.
"
Class {
	#name : #GtLACPChatEndMarker,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #converting }
GtLACPChatEndMarker >> asElement [
 ^ BrFrame new id: self id; hMatchParent; vExact: 1; yourself
]

{ #category : #accessing }
GtLACPChatEndMarker >> elementIdAt: anIndex [
 ^ self id
]

{ #category : #accessing }
GtLACPChatEndMarker >> id [
 ^ #'acp-stream-end'
]

{ #category : #accessing }
GtLACPChatEndMarker >> renderingKey [
 ^ { self }
]
