Class {
	#name : #GtOpenAIModel,
	#superclass : #GtLlmEntity,
	#instVars : [
		'created',
		'object',
		'ownedBy',
		'id'
	],
	#category : #Gt4OpenAI
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
	created := self deserializeTime: anObject
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
