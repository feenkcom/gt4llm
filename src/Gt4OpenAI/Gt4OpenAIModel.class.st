Class {
	#name : #Gt4OpenAIModel,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'created',
		'object',
		'ownedBy',
		'id'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIModel class >> serializationProperties [
	^ {#created -> #created.
		#id -> #id.
		#object -> #object.
		#owned_by -> #ownedBy}
]

{ #category : #accessing }
Gt4OpenAIModel >> created [
	^ created
]

{ #category : #accessing }
Gt4OpenAIModel >> created: anObject [
	created := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
Gt4OpenAIModel >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIModel >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIModel >> object [
	^ object
]

{ #category : #accessing }
Gt4OpenAIModel >> object: anObject [
	object := anObject
]

{ #category : #accessing }
Gt4OpenAIModel >> ownedBy [
	^ ownedBy
]

{ #category : #accessing }
Gt4OpenAIModel >> ownedBy: anObject [
	ownedBy := anObject
]
