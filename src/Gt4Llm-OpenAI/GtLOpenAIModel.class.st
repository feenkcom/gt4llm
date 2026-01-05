Class {
	#name : #GtLOpenAIModel,
	#superclass : #GtLEntity,
	#instVars : [
		'created',
		'object',
		'ownedBy',
		'id'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIModel class >> leJsonV4Name [

	^ #gtLOpenAIModel
]

{ #category : #accessing }
GtLOpenAIModel class >> serializationProperties [
	^ {#created -> #created.
		#id -> #id.
		#object -> #object.
		#owned_by -> #ownedBy}
]

{ #category : #accessing }
GtLOpenAIModel >> created [
	^ created
]

{ #category : #accessing }
GtLOpenAIModel >> created: anObject [
	created := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIModel >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIModel >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIModel >> object [
	^ object
]

{ #category : #accessing }
GtLOpenAIModel >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLOpenAIModel >> ownedBy [
	^ ownedBy
]

{ #category : #accessing }
GtLOpenAIModel >> ownedBy: anObject [
	ownedBy := anObject
]
