Class {
	#name : #GtOpenAIModel,
	#superclass : #GtOpenAIEntity,
	#instVars : [
		'created',
		'object',
		'ownedBy',
		'id'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIModel class >> serializationProperties [
	^ {#created -> #created.
		#id -> #id.
		#object -> #object.
		#owned_by -> #ownedBy}
]

{ #category : #accessing }
GtOpenAIModel >> created [
	^ created
]

{ #category : #accessing }
GtOpenAIModel >> created: anObject [
	created := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
GtOpenAIModel >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIModel >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIModel >> object [
	^ object
]

{ #category : #accessing }
GtOpenAIModel >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtOpenAIModel >> ownedBy [
	^ ownedBy
]

{ #category : #accessing }
GtOpenAIModel >> ownedBy: anObject [
	ownedBy := anObject
]
