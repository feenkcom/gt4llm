Class {
	#name : #Gt4OpenAIAssistant,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'createdAt',
		'name',
		'description',
		'model',
		'instructions',
		'tools',
		'fileIds',
		'metadata'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIAssistant class >> serializationProperties [
	^ {
  #id -> #id.
  #created_at -> #createdAt.
  #name -> #name.
  #description -> #description.
  #model -> #model.
  #instructions -> #instructions.
  #tools -> #tools.
  #file_ids -> #fileIds.
  #metadata -> #metadata
}
]

{ #category : #accessing }
Gt4OpenAIAssistant >> createdAt [
	^ createdAt
]

{ #category : #accessing }
Gt4OpenAIAssistant >> createdAt: anObject [
	createdAt := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> description [
	^ description
]

{ #category : #accessing }
Gt4OpenAIAssistant >> description: anObject [
	description := anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> fileIds [
	^ fileIds
]

{ #category : #accessing }
Gt4OpenAIAssistant >> fileIds: anObject [
	fileIds := anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIAssistant >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> instructions [
	^ instructions
]

{ #category : #accessing }
Gt4OpenAIAssistant >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> metadata [
	^ metadata
]

{ #category : #accessing }
Gt4OpenAIAssistant >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> model [
	^ model
]

{ #category : #accessing }
Gt4OpenAIAssistant >> model: anObject [
	model := anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> name [
	^ name
]

{ #category : #accessing }
Gt4OpenAIAssistant >> name: anObject [
	name := anObject
]

{ #category : #accessing }
Gt4OpenAIAssistant >> serialize [
	| serialized |
	serialized := super serialize.
	serialized at: #tools put: ((serialized at: #tools) collect: #serialize).
	^ serialized
]

{ #category : #accessing }
Gt4OpenAIAssistant >> tools [
	^ tools
]

{ #category : #accessing }
Gt4OpenAIAssistant >> tools: anObject [
	tools := anObject
]
