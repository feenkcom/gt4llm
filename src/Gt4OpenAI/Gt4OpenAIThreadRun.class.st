Class {
	#name : #Gt4OpenAIThreadRun,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'createdAt',
		'assistantId',
		'threadId',
		'status',
		'startedAt',
		'expiresAt',
		'cancelledAt',
		'failedAt',
		'completedAt',
		'lastError',
		'model',
		'instructions',
		'tools',
		'fileIds',
		'metadata',
		'usage'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIThreadRun class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#assistant_id -> #assistantId.
		#thread_id -> #threadId.
		#status -> #status.
		#started_at -> #startedAt.
		#expires_at -> #expiresAt.
		#cancelled_at -> #cancelledAt.
		#failed_at -> #failedAt.
		#completed_at -> #completedAt.
		#last_error -> #lastError.
		#model -> #model.
		#instructions -> #instructions.
		#tools -> #tools.
		#file_ids -> #fileIds.
		#metadata -> #metadata.
		#usage -> #usage}
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> assistantId [
	^ assistantId
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> cancelledAt [
	^ cancelledAt
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> cancelledAt: anObject [
	cancelledAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> completedAt [
	^ completedAt
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> completedAt: anObject [
	completedAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> createdAt [
	^ createdAt
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> expiresAt [
	^ expiresAt
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> expiresAt: anObject [
	expiresAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> failedAt [
	^ failedAt
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> failedAt: anObject [
	failedAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> fileIds [
	^ fileIds
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> fileIds: anObject [
	fileIds := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> instructions [
	^ instructions
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> lastError [
	^ lastError
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> lastError: anObject [
	lastError := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> metadata [
	^ metadata
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> model [
	^ model
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> model: anObject [
	model := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> startedAt [
	^ startedAt
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> startedAt: anObject [
	startedAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> status [
	^ status
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> status: anObject [
	status := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> threadId [
	^ threadId
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> threadId: anObject [
	threadId := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> tools [
	^ tools
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> tools: anObject [
	tools := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> usage [
	^ usage
]

{ #category : #accessing }
Gt4OpenAIThreadRun >> usage: anObject [
	usage := anObject
]
