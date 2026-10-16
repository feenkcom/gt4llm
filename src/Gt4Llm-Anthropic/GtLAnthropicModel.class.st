Class {
	#name : #GtLAnthropicModel,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'displayName',
		'createdAt'
	],
	#category : #'Gt4Llm-Anthropic-Model'
}

{ #category : #accessing }
GtLAnthropicModel class >> leJsonV4Name [

	^ #gtLAnthropicModel
]

{ #category : #'as yet unclassified' }
GtLAnthropicModel class >> serializationProperties [
	^ {#id -> #id.
		#display_name -> #displayName.
		#created_at -> #createdAt}
]

{ #category : #accessing }
GtLAnthropicModel >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLAnthropicModel >> createdAt: anObject [
	createdAt := DateAndTime fromString: anObject
]

{ #category : #accessing }
GtLAnthropicModel >> displayName [
	^ displayName
]

{ #category : #accessing }
GtLAnthropicModel >> displayName: anObject [
	displayName := anObject
]

{ #category : #accessing }
GtLAnthropicModel >> id [
	^ id
]

{ #category : #accessing }
GtLAnthropicModel >> id: anObject [
	id := anObject
]
