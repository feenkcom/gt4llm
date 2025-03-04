Class {
	#name : #GtOpenAIThreadRun,
	#superclass : #GtLlmEntity,
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
		'usage',
		'files'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIThreadRun class >> serializationProperties [
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
GtOpenAIThreadRun >> assistantId [
	^ assistantId
]

{ #category : #accessing }
GtOpenAIThreadRun >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> cancelledAt [
	^ cancelledAt
]

{ #category : #accessing }
GtOpenAIThreadRun >> cancelledAt: anObject [
	cancelledAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> completedAt [
	^ completedAt
]

{ #category : #accessing }
GtOpenAIThreadRun >> completedAt: anObject [
	completedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIThreadRun >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> doneAt [
	^ self cancelledAt ifNil: [ self completedAt ifNil: [ self failedAt ] ]
]

{ #category : #accessing }
GtOpenAIThreadRun >> expiresAt [
	^ expiresAt
]

{ #category : #accessing }
GtOpenAIThreadRun >> expiresAt: anObject [
	expiresAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> failedAt [
	^ failedAt
]

{ #category : #accessing }
GtOpenAIThreadRun >> failedAt: anObject [
	failedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> failureMessage [
	^ self lastError at: 'message'
]

{ #category : #accessing }
GtOpenAIThreadRun >> fileIds [
	^ fileIds
]

{ #category : #accessing }
GtOpenAIThreadRun >> fileIds: anObject [
	fileIds := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> files [
	^ files
		ifNil: [ files := GtOpenAIFilesGroup
					withAll: (self fileIds collect: [ :aFileId | self client getFile: aFileId ]) ]
]

{ #category : #accessing }
GtOpenAIThreadRun >> gtErrorFor: aView [
	<gtView>
	self isFailed ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Failure';
		priority: 1;
		text: [ self failureMessage ]
]

{ #category : #accessing }
GtOpenAIThreadRun >> gtFilesFor: aView [
	<gtView>
	^ aView forward
		title: 'Files';
		priority: 5;
		object: [ self files ];
		view: #gtFilesFor:
]

{ #category : #accessing }
GtOpenAIThreadRun >> gtToolsFor: aView [
	<gtView>
	^ aView list
		title: 'Tools';
		priority: 2;
		items: [ self tools ];
		itemText: #type
]

{ #category : #accessing }
GtOpenAIThreadRun >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIThreadRun >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> initialize [
	super initialize.
	
	fileIds := OrderedCollection new
]

{ #category : #accessing }
GtOpenAIThreadRun >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIThreadRun >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> isCancelled [
	^ self status = 'cancelled'
]

{ #category : #accessing }
GtOpenAIThreadRun >> isCancelling [
	^ self status = 'cancelling'
]

{ #category : #accessing }
GtOpenAIThreadRun >> isCompleted [
	^ self status = 'completed'
]

{ #category : #accessing }
GtOpenAIThreadRun >> isDone [
	^ self isCancelled
		or: [ self isExpired or: [ self isFailed or: [ self isCompleted ] ] ]
]

{ #category : #accessing }
GtOpenAIThreadRun >> isExpired [
	^ self status = 'expired'
]

{ #category : #accessing }
GtOpenAIThreadRun >> isFailed [
	^ self status = 'failed'
]

{ #category : #accessing }
GtOpenAIThreadRun >> isInProgress [
	^ self status = 'in_progress'
]

{ #category : #accessing }
GtOpenAIThreadRun >> isQueued [
	^ self status = 'queued'
]

{ #category : #accessing }
GtOpenAIThreadRun >> isRequiringAction [
	^ self status = 'requires_action'
]

{ #category : #accessing }
GtOpenAIThreadRun >> lastError [
	^ lastError
]

{ #category : #accessing }
GtOpenAIThreadRun >> lastError: anObject [
	lastError := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> metadata [
	^ metadata
]

{ #category : #accessing }
GtOpenAIThreadRun >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIThreadRun >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> startedAt [
	^ startedAt
]

{ #category : #accessing }
GtOpenAIThreadRun >> startedAt: anObject [
	startedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> status [
	^ status
]

{ #category : #accessing }
GtOpenAIThreadRun >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtOpenAIThreadRun >> threadId [
	^ threadId
]

{ #category : #accessing }
GtOpenAIThreadRun >> threadId: anObject [
	threadId := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIThreadRun >> toolCalls [
	^ ((self rawData at: 'required_action' at: 'submit_tool_outputs')
		at: 'tool_calls') collect: [ :aDict | GtLlmFunctionToolCall from: aDict ]
]

{ #category : #accessing }
GtOpenAIThreadRun >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIThreadRun >> tools: anObject [
	tools := anObject collect: [ :aValue | GtLlmTool from: aValue ]
]

{ #category : #accessing }
GtOpenAIThreadRun >> usage [
	^ usage
]

{ #category : #accessing }
GtOpenAIThreadRun >> usage: anObject [
	usage := anObject ifNotNil: [ GtOpenAIUsage from: anObject ]
]
