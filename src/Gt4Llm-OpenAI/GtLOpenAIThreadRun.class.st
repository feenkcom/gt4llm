Class {
	#name : #GtLOpenAIThreadRun,
	#superclass : #GtLEntity,
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
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIThreadRun class >> leJsonV4Name [

	^ #gtOpenAIThreadRun
]

{ #category : #accessing }
GtLOpenAIThreadRun class >> serializationProperties [
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
GtLOpenAIThreadRun >> assistantId [
	^ assistantId
]

{ #category : #accessing }
GtLOpenAIThreadRun >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> cancelledAt [
	^ cancelledAt
]

{ #category : #accessing }
GtLOpenAIThreadRun >> cancelledAt: anObject [
	cancelledAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> completedAt [
	^ completedAt
]

{ #category : #accessing }
GtLOpenAIThreadRun >> completedAt: anObject [
	completedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIThreadRun >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> doneAt [
	^ self cancelledAt ifNil: [ self completedAt ifNil: [ self failedAt ] ]
]

{ #category : #accessing }
GtLOpenAIThreadRun >> expiresAt [
	^ expiresAt
]

{ #category : #accessing }
GtLOpenAIThreadRun >> expiresAt: anObject [
	expiresAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> failedAt [
	^ failedAt
]

{ #category : #accessing }
GtLOpenAIThreadRun >> failedAt: anObject [
	failedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> failureMessage [
	^ self lastError at: 'message'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> fileIds [
	^ fileIds
]

{ #category : #accessing }
GtLOpenAIThreadRun >> fileIds: anObject [
	fileIds := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> files [
	^ files
		ifNil: [ files := GtLOpenAIFilesGroup
					withAll: (self fileIds collect: [ :aFileId | self client getFile: aFileId ]) ]
]

{ #category : #'gt - extensions' }
GtLOpenAIThreadRun >> gtActionReloadFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons refresh;
		tooltip: 'Reload';
		priority: 5;
		action: [ :aButton | aButton phlow spawnObject: (self client getRun: self id forThread: self threadId) ]
]

{ #category : #accessing }
GtLOpenAIThreadRun >> gtErrorFor: aView [
	<gtView>
	self isFailed ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Failure';
		priority: 1;
		text: [ self failureMessage ]
]

{ #category : #accessing }
GtLOpenAIThreadRun >> gtFilesFor: aView [
	<gtView>
	^ aView forward
		title: 'Files';
		priority: 5;
		object: [ self files ];
		view: #gtFilesFor:
]

{ #category : #accessing }
GtLOpenAIThreadRun >> gtToolsFor: aView [
	<gtView>
	^ aView list
		title: 'Tools';
		priority: 2;
		items: [ self tools ];
		itemText: #type
]

{ #category : #accessing }
GtLOpenAIThreadRun >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIThreadRun >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> initialize [
	super initialize.
	
	fileIds := OrderedCollection new
]

{ #category : #accessing }
GtLOpenAIThreadRun >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOpenAIThreadRun >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isCancelled [
	^ self status = 'cancelled'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isCancelling [
	^ self status = 'cancelling'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isCompleted [
	^ self status = 'completed'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isDone [
	^ self isCancelled
		or: [ self isExpired or: [ self isFailed or: [ self isCompleted ] ] ]
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isExpired [
	^ self status = 'expired'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isFailed [
	^ self status = 'failed'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isInProgress [
	^ self status = 'in_progress'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isQueued [
	^ self status = 'queued'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> isRequiringAction [
	^ self status = 'requires_action'
]

{ #category : #accessing }
GtLOpenAIThreadRun >> lastError [
	^ lastError
]

{ #category : #accessing }
GtLOpenAIThreadRun >> lastError: anObject [
	lastError := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> metadata [
	^ metadata
]

{ #category : #accessing }
GtLOpenAIThreadRun >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIThreadRun >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> startedAt [
	^ startedAt
]

{ #category : #accessing }
GtLOpenAIThreadRun >> startedAt: anObject [
	startedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> status [
	^ status
]

{ #category : #accessing }
GtLOpenAIThreadRun >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtLOpenAIThreadRun >> threadId [
	^ threadId
]

{ #category : #accessing }
GtLOpenAIThreadRun >> threadId: anObject [
	threadId := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIThreadRun >> toolCalls [
	^ ((self rawData at: 'required_action' at: 'submit_tool_outputs')
		at: 'tool_calls') collect: [ :aDict | GtLFunctionToolCall from: aDict ]
]

{ #category : #accessing }
GtLOpenAIThreadRun >> tools [
	^ tools
]

{ #category : #accessing }
GtLOpenAIThreadRun >> tools: anObject [
	tools := anObject collect: [ :aValue | GtLlmTool from: aValue ]
]

{ #category : #accessing }
GtLOpenAIThreadRun >> usage [
	^ usage
]

{ #category : #accessing }
GtLOpenAIThreadRun >> usage: anObject [
	usage := anObject ifNotNil: [ GtLOpenAIUsage from: anObject ]
]
