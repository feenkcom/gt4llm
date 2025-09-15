Class {
	#name : #GtOpenAIFineTuningEvent,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'createdAt',
		'level',
		'message',
		'data',
		'type'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFineTuningEvent class >> leJsonV4Name [

	^ #gtOpenAIFineTuningEvent
]

{ #category : #accessing }
GtOpenAIFineTuningEvent class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#level -> #level.
		#message -> #message.
		#data -> #data.
		#type -> #type}
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> data [
	^ data
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> data: anObject [
	data := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> level [
	^ level
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> level: anObject [
	level := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> message [
	^ message
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> type [
	^ type
]

{ #category : #accessing }
GtOpenAIFineTuningEvent >> type: anObject [
	type := anObject
]
