Class {
	#name : #GtAnthropicModel,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'displayName',
		'createdAt'
	],
	#category : #'Gt4Anthropic-Models'
}

{ #category : #'as yet unclassified' }
GtAnthropicModel class >> serializationProperties [
	^ {#id -> #id.
		#display_name -> #displayName.
		#created_at -> #createdAt}
]

{ #category : #accessing }
GtAnthropicModel >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtAnthropicModel >> createdAt: anObject [
	createdAt := DateAndTime fromString: anObject
]

{ #category : #accessing }
GtAnthropicModel >> displayName [
	^ displayName
]

{ #category : #accessing }
GtAnthropicModel >> displayName: anObject [
	displayName := anObject
]

{ #category : #accessing }
GtAnthropicModel >> id [
	^ id
]

{ #category : #accessing }
GtAnthropicModel >> id: anObject [
	id := anObject
]
