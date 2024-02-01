Class {
	#name : #Gt4OpenAIThread,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'createdAt',
		'metadata'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIThread class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#metadata -> #metadata}
]

{ #category : #accessing }
Gt4OpenAIThread >> createdAt [
	^ createdAt
]

{ #category : #accessing }
Gt4OpenAIThread >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThread >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIThread >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIThread >> metadata [
	^ metadata
]

{ #category : #accessing }
Gt4OpenAIThread >> metadata: anObject [
	metadata := anObject
]
