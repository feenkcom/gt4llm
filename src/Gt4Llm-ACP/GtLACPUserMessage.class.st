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

{ #category : #accessing }
GtLACPUserMessage >> finalMessages [
 ^ { self }
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
