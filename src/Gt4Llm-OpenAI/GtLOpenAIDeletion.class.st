Class {
	#name : #GtLOpenAIDeletion,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'object',
		'isDeleted'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIDeletion class >> serializationProperties [
	^ {#id -> #id.
		#object -> #object.
		#deleted -> #isDeleted}
]

{ #category : #accessing }
GtLOpenAIDeletion >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIDeletion >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIDeletion >> isDeleted [
	^ isDeleted
]

{ #category : #accessing }
GtLOpenAIDeletion >> isDeleted: anObject [
	isDeleted := anObject
]

{ #category : #accessing }
GtLOpenAIDeletion >> object [
	^ object
]

{ #category : #accessing }
GtLOpenAIDeletion >> object: anObject [
	object := anObject
]
