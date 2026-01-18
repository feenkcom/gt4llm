Class {
	#name : #GtLOpenAIMessage,
	#superclass : #GtLChatMessage,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'instance creation' }
GtLOpenAIMessage class >> from: aDict [
	^ self new from: aDict
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #testing }
GtLOpenAIMessage >> hasResponse [
	^ self contentText isNotEmpty
]
