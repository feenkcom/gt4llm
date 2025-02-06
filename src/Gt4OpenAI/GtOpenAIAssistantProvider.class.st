Class {
	#name : #GtOpenAIAssistantProvider,
	#superclass : #GtOpenAIProvider,
	#instVars : [
		'assistant',
		'instructions',
		'assistantName',
		'assistantDescription',
		'tools',
		'thread',
		'lastRun',
		'future'
	],
	#category : #'Gt4OpenAI-Providers'
}

{ #category : #accessing }
GtOpenAIAssistantProvider >> assistant [
	^ assistant
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> assistantDescription [
	^ assistantDescription
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> assistantDescription: anObject [
	assistantDescription := anObject
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> assistantName [
	^ assistantName
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> assistantName: anObject [
	assistantName := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> createAssistant [
	self assistant ifNotNil: [ self deleteAssistant ].

	assistant := client
			createAssistant: (GtOpenAIAssistant new
					model: self model;
					name: self assistantName;
					description: self assistantDescription;
					instructions: self instructions;
					tools: self tools).
					
	thread := client createThreadWithMessages: {}.

	self class finalizationRegistry add: self
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultAssistantDescription [
	^ 'An assistant in Glamorous Toolkit.'
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultAssistantMessageClass [
	^ OpenAIMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultAssistantName [
	^ 'Tutor - ' , FileLocator home basename
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultTools [
	^ {}
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultUserMessageClass [
	^ OpenAIMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> deleteAssistant [
	[ client deleteAssistant: assistant id.
	assistant := nil ] on: GtOpenAIError do: [ assistant := nil ]
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> finalize [
	self assistant ifNotNil: [ self deleteAssistant ].

	super finalize
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> format: anObject [
	format := {'type' -> 'json_schema'.
			'json_schema'
				-> {'name' -> 'ResponseFormat'.
						'strict' -> true.
						'schema' -> anObject} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> getRun [
	^ client getRun: lastRun id forThread: thread id
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> initialize [
	super initialize.

	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> instructions: anObject [
	instructions := anObject.
	
	self createAssistant
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> lastRun [
	^ lastRun
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> runFuture [
	^ GtLlmThreadRunFuture new chat: self
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> sendAssistantMessage: aMessage [
	chat addMessage: aMessage.
	client addMessage: aMessage toThread: thread id.

	lastRun := client
			createRunForThread: thread id
			usingAssistant: assistant id
			andResponseFormat: self format.
			
	self updateMessages.

	chat signalRunHasStarted.

	future := (self runFuture
			then: [ :aRun | 
				chat signalRunIsDone: aRun.
				self updateMessages ])
			await: GtOpenAIUtilities executionConfiguration
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> status [
	^ GtLlmAssistantChatStatus forLastRun: lastRun
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIAssistantProvider >> tools: anObject [
	tools := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> updateMessages [
	chat
		messages: (thread updateMessages
				collect: [ :aThreadMessage | self assistantMessageClass new from: aThreadMessage serialize ])
]
