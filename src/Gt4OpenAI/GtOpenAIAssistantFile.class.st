Class {
	#name : #GtOpenAIAssistantFile,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'createdAt',
		'assistantId'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIAssistantFile class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#assistant_id -> #assistantId}
]

{ #category : #accessing }
GtOpenAIAssistantFile >> assistantId [
	^ assistantId
]

{ #category : #accessing }
GtOpenAIAssistantFile >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
GtOpenAIAssistantFile >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIAssistantFile >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIAssistantFile >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIAssistantFile >> id: anObject [
	id := anObject
]
