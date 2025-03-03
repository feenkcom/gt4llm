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
		'future',
		'files',
		'apiFiles'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> addFile: aFile [
	files add: aFile
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> addTool: aTool [
	tools add: aTool
]

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

	files
		do: [ :aFile | 
			apiFiles
				at: (client uploadFile: aFile file withPurpose: 'assistants') id
				put: aFile ].

	assistant := GtOpenAIAssistant new
			model: self model;
			name: self assistantName;
			description: self assistantDescription;
			instructions: self instructions;
			tools: self tools.

	files
		ifNotEmpty: [ assistant
				toolResources: {'file_search'
							-> {'vector_stores' -> {{'file_ids' -> apiFiles keys} asDictionary}} asDictionary}
						asDictionary ].

	assistant := client createAssistant: assistant.

	thread := client createThreadWithMessages: {}.


	self class finalizationRegistry add: self
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultAssistantDescription [
	^ 'An assistant in Glamorous Toolkit.'
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultAssistantMessageClass [
	^ GtOpenAIMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultAssistantName [
	^ 'Tutor - ' , FileLocator home basename
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultTools [
	^ GtLlmToolsGroup new
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> defaultUserMessageClass [
	^ GtOpenAIMessage
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
GtOpenAIAssistantProvider >> getApiFile: anId [
	^ apiFiles at: anId
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> getMessages [
	^ thread updateMessages
		collect: [ :aThreadMessage | 
			self assistantMessageClass adoptInstance: aThreadMessage.
			aThreadMessage ]
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> getRun [
	lastRun := client getRun: lastRun id forThread: thread id.

	lastRun isRequiringAction ifTrue: [ lastRun := self performToolCalls ].

	^ lastRun
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> gtFilesFor: aView [
	<gtView>
	files ifEmpty: [ ^ aView empty ].

	^ aView forward
		title: 'Files';
		priority: 5;
		object: [ files ];
		view: #gtFilesFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> initialize [
	super initialize.

	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools.
	files := GtOpenAIResourceFilesGroup new.
	apiFiles := Dictionary new
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
GtOpenAIAssistantProvider >> performToolCalls [
	| toolOutputs |
	toolOutputs := lastRun toolCalls
			collect: [ :aToolCall | 
				| toolOutput |
				toolOutput := tools performToolCall: aToolCall.
				chat
					addMessage: (GtLlmToolMessage new
							toolCall: aToolCall;
							output: toolOutput).
				{'tool_call_id' -> aToolCall id.
					'output' -> toolOutput} asDictionary ].

	^ client
		submitToolOutputs: toolOutputs
		toThread: thread id
		anRun: lastRun id
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantProvider >> sendAssistantMessage: aMessage [
	chat addMessage: aMessage.

	chat signalRunHasStarted.

	client addMessage: aMessage toThread: thread id.

	lastRun := client
			createRunForThread: thread id
			usingAssistant: assistant id
			andResponseFormat: self format.

	self updateMessages.

	chat signalRunHasUpdated.

	self executeWait
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
	| newMessages nonToolMessages |
	newMessages := self getMessages.
	nonToolMessages := chat messages reject: #isToolRole.

	newMessages
		doWithIndex: [ :aMessage :anIndex | 
			anIndex > nonToolMessages size
				ifTrue: [ chat addMessage: aMessage ]
				ifFalse: [ (nonToolMessages at: anIndex) merge: aMessage ] ]
]
