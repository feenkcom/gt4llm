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
GtLOpenAIMessage class >> serializationProperties [
	^ {
		#content -> #contentText.
		#created_at -> #createdAtString.
		#id -> #idString.
		#role -> #role
	}
]

{ #category : #accessing }
GtLOpenAIMessage >> contentJson [
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAtString [
	^ nil
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAtString: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #testing }
GtLOpenAIMessage >> hasResponse [
	^ self contentText isNotEmpty
]

{ #category : #accessing }
GtLOpenAIMessage >> idString [
	^ nil
]

{ #category : #accessing }
GtLOpenAIMessage >> idString: anObject [
	id := anObject
]
