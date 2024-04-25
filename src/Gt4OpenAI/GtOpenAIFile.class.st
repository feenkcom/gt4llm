Class {
	#name : #GtOpenAIFile,
	#superclass : #GtLlmEntity,
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
GtOpenAIFile class >> serializationProperties [
	^ {#id -> #id.
		#purpose -> #purpose.
		#filename -> #filename.
		#bytes -> #bytes.
		#created_at -> #createdAt.
		#status -> #status.
		#status_details -> #statusDetails}
]

{ #category : #accessing }
GtOpenAIFile >> bytes [
	^ bytes
]

{ #category : #accessing }
GtOpenAIFile >> bytes: anObject [
	bytes := anObject
]

{ #category : #accessing }
GtOpenAIFile >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIFile >> createdAt: anObject [
	createdAt := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
GtOpenAIFile >> filename [
	^ filename
]

{ #category : #accessing }
GtOpenAIFile >> filename: anObject [
	filename := anObject
]

{ #category : #accessing }
GtOpenAIFile >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIFile >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIFile >> isAssistantsOutput [
	^ self purpose = 'assistants-output'
]

{ #category : #accessing }
GtOpenAIFile >> isError [
	^ self status = 'error'
]

{ #category : #accessing }
GtOpenAIFile >> isFinetuningResults [
	^ self purpose = 'fine-tune-results'
]

{ #category : #accessing }
GtOpenAIFile >> isForAssistants [
	^ self purpose = 'assistants'
]

{ #category : #accessing }
GtOpenAIFile >> isForFinetuning [
	^ self purpose = 'fine-tune'
]

{ #category : #accessing }
GtOpenAIFile >> isProcessed [
	^ self status = 'processed'
]

{ #category : #accessing }
GtOpenAIFile >> isUploaded [
	^ self status = 'uploaded'
]

{ #category : #accessing }
GtOpenAIFile >> purpose [
	^ purpose
]

{ #category : #accessing }
GtOpenAIFile >> purpose: anObject [
	purpose := anObject
]

{ #category : #accessing }
GtOpenAIFile >> status [
	^ status
]

{ #category : #accessing }
GtOpenAIFile >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtOpenAIFile >> statusDetails [
	^ statusDetails
]

{ #category : #accessing }
GtOpenAIFile >> statusDetails: anObject [
	statusDetails := anObject
]
