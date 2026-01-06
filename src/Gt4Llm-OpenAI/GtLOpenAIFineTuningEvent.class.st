Class {
	#name : #GtLOpenAIFineTuningEvent,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'createdAt',
		'level',
		'message',
		'data',
		'type'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFineTuningEvent class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#level -> #level.
		#message -> #message.
		#data -> #data.
		#type -> #type}
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> data [
	^ data
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> data: anObject [
	data := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> level [
	^ level
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> level: anObject [
	level := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> message [
	^ message
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> type [
	^ type
]

{ #category : #accessing }
GtLOpenAIFineTuningEvent >> type: anObject [
	type := anObject
]
