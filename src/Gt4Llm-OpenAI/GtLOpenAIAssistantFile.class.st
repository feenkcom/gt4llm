Class {
	#name : #GtLOpenAIAssistantFile,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'createdAt',
		'assistantId'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIAssistantFile class >> leJsonV4Name [

	^ #gtLOpenAIAssistantFile
]

{ #category : #accessing }
GtLOpenAIAssistantFile class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#assistant_id -> #assistantId}
]

{ #category : #accessing }
GtLOpenAIAssistantFile >> assistantId [
	^ assistantId
]

{ #category : #accessing }
GtLOpenAIAssistantFile >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
GtLOpenAIAssistantFile >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIAssistantFile >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIAssistantFile >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIAssistantFile >> id: anObject [
	id := anObject
]
