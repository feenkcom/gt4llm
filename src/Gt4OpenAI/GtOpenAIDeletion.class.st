Class {
	#name : #GtOpenAIDeletion,
	#superclass : #GtOpenAIEntity,
	#instVars : [
		'id',
		'object',
		'isDeleted'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIDeletion class >> serializationProperties [
	^ {#id -> #id.
		#object -> #object.
		#deleted -> #isDeleted}
]

{ #category : #accessing }
GtOpenAIDeletion >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIDeletion >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIDeletion >> isDeleted [
	^ isDeleted
]

{ #category : #accessing }
GtOpenAIDeletion >> isDeleted: anObject [
	isDeleted := anObject
]

{ #category : #accessing }
GtOpenAIDeletion >> object [
	^ object
]

{ #category : #accessing }
GtOpenAIDeletion >> object: anObject [
	object := anObject
]
