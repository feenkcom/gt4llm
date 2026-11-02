"
I represent a user prompt with its content blocks. I expose the same chat presentation interface as an assistant response, with no tool or reasoning activity.
"
Class {
	#name : #GtLACPUserMessage,
	#superclass : #GtLACPConversationMessage,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPUserMessage >> activityItems [
 ^ #()
]

{ #category : #converting }
GtLACPUserMessage >> asElement [
 ^ (GtLACPChatMessageViewModel new message: self; yourself) asElement
]

{ #category : #converting }
GtLACPUserMessage >> chatElementClass [
 ^ GtLACPUserMessageElement
]

{ #category : #accessing }
GtLACPUserMessage >> chatLabel [
 ^ 'You'
]

{ #category : #accessing }
GtLACPUserMessage >> finalMessages [
 ^ { self }
]

{ #category : #testing }
GtLACPUserMessage >> hasCompletedReply [
 ^ false
]

{ #category : #accessing }
GtLACPUserMessage >> initialize [
 super initialize.
 role := #user
]

{ #category : #accessing }
GtLACPUserMessage >> messages [
 ^ { self }
]

{ #category : #accessing }
GtLACPUserMessage >> toolCalls [
 ^ #()
]
