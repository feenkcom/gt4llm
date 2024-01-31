Class {
	#name : #Gt4OpenAIFile,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'purpose',
		'filename',
		'bytes',
		'createdAt',
		'status',
		'statusDetails'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIFile class >> serializationProperties [
	^ {#id -> #id.
		#purpose -> #purpose.
		#filename -> #filename.
		#bytes -> #bytes.
		#created_at -> #createdAt.
		#status -> #status.
		#status_details -> #statusDetails}
]

{ #category : #accessing }
Gt4OpenAIFile >> bytes [
	^ bytes
]

{ #category : #accessing }
Gt4OpenAIFile >> bytes: anObject [
	bytes := anObject
]

{ #category : #accessing }
Gt4OpenAIFile >> createdAt [
	^ createdAt
]

{ #category : #accessing }
Gt4OpenAIFile >> createdAt: anObject [
	createdAt := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
Gt4OpenAIFile >> filename [
	^ filename
]

{ #category : #accessing }
Gt4OpenAIFile >> filename: anObject [
	filename := anObject
]

{ #category : #accessing }
Gt4OpenAIFile >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIFile >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIFile >> purpose [
	^ purpose
]

{ #category : #accessing }
Gt4OpenAIFile >> purpose: anObject [
	purpose := anObject
]

{ #category : #accessing }
Gt4OpenAIFile >> status [
	^ status
]

{ #category : #accessing }
Gt4OpenAIFile >> status: anObject [
	status := anObject
]

{ #category : #accessing }
Gt4OpenAIFile >> statusDetails [
	^ statusDetails
]

{ #category : #accessing }
Gt4OpenAIFile >> statusDetails: anObject [
	statusDetails := anObject
]
