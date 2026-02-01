Class {
	#name : #GtLOpenAIProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'client',
		'isStreaming',
		'executions',
		'tools',
		'modelName'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> default [
	^ [ self withApiKeyFromFile ]
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> isConnectable [
	^ GtLOpenAIClient apiKeyFile exists
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> providerName [
	^ 'OpenAI provider'
]

{ #category : #'instance creation' }
GtLOpenAIProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtLOpenAIClient apiKeyFileContents
]

{ #category : #accessing }
GtLOpenAIProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> beNotStreaming [
	isStreaming := false
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> beStreaming [
	isStreaming := true
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> client [
	^ client
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> defaultAssistantMessageClass [
	^ GtLOpenAIAssistantMessage
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> defaultUserMessageClass [
	^ GtLOpenAIUserMessage
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> executeAsyncMessage: anInputMessage [
	<return: #TAsyncPromise>
	| anErrorHandlerPromise aFuture aFirstPromise |
	self privateExecutionState: self state scheduled.
	aFuture := [ 
		self privateExecutionState: self state running.
		self processNextMessage: anInputMessage ] asAsyncFuture.
	aFirstPromise := aFuture await: GtLOpenAISettings futureExecutionConfiguration.
	anErrorHandlerPromise := aFirstPromise
			then: [ :aProcessedMessage | 
				self privateExecutionState: self state finished.
				aProcessedMessage ]
			otherwise: [ :anError | 
				| anErrorMessage |
				anErrorMessage := GtLErrorMessage new
						freeze: anError;
						inputMessage: anInputMessage.
				self chat addErrorMessage: anErrorMessage.
				self privateExecutionState: self state finished.
				self chat signalRunIsDone.
				anErrorMessage ].
	executions add: anErrorHandlerPromise.
	^ anErrorHandlerPromise
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> executions [
	^ executions
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> format: anObject [
	super format: anObject.
	
	self beNotStreaming
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #views }
GtLOpenAIProvider >> gtViewCallsWithTokensFor: aView [
	<gtView>
	^(aView forward)
		title: 'Tokens by call';
		priority: 30;
		object: [client];
		view: #gtViewCallsWithTokensFor:
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> handleToolCall: aToolCall [
	| domainObject toolMessage |
	chat removeLastMessage.
	toolMessage := GtLToolMessage new toolCall: aToolCall.
	chat addToolMessage: toolMessage.
	toolMessage beRunningExecutionState.
	[ domainObject := tools performToolCall: aToolCall.
	toolMessage output: domainObject ]
		ensure: [ toolMessage beFinishedExecutionState ].
	self chat signalRunHasUpdated.
	
	"Let's review this when isStreaming works (is used).
	Do we need to call #executeAsyncMessage: 
	or can we call #processNextMessage:?"
	self flag: #todo.
	self executeAsyncMessage: toolMessage
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> initialize [
	super initialize.
	modelName := nil.	"set when the provider is built"
	client := GtLOpenAIClient new.
	executions := OrderedCollection new.
	isStreaming := true.
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> isStreaming: aBoolean [
	isStreaming := aBoolean
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLOpenAIProvider >> modelName: aString [
	modelName := aString
]

{ #category : #accessing }
GtLOpenAIProvider >> performToolCallsIn: result with: activeTools [
	<return: #GtLOpenAIProviderProcessedMessage or: nil>
	| toolMessages |
	toolMessages := result toolCalls
			collect: [ :aToolCall | 
				| domainObject toolMessage |
				toolMessage := GtLToolMessage new toolCall: aToolCall.
				chat addToolMessage: toolMessage.

				self state
					ifCanContinue: [ toolMessage beRunningExecutionState.
						[ domainObject := activeTools performToolCall: aToolCall.
						toolMessage output: domainObject ]
							ensure: [ toolMessage beFinishedExecutionState ] ]
					ifDisabled: [ toolMessage beSkippedExecutionState ].
				
				toolMessage ]
			as: Array.
	self chat signalRunHasUpdated.
	
	"We send all chat messages, so it is enough to process just the last tool message.
	See: `GtLOpenAIGenerateResponseAPICommand>>#buildEntity`."
	toolMessages ifEmpty: [ ^ nil ].
	^ self processNextMessage: toolMessages last.
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self modelName;
		nextPutAll: ', ';
		nextPutAll: (self state ifNotNil: #label) asString;
		nextPut: $)
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> processNextMessage: anInputMessage [
	<return: #GtLOpenAIProviderProcessedMessage or: nil>
	| result anOutputMessage anotherMessage |
	"continue"
	self state ifCanContinue: [  ] ifDisabled: [ ^ nil ].
	result := client
			generateResponseWithModel: self modelName
			messages: self relevantChatMessages
			instructions: anInputMessage completeInstructionString
			tools: anInputMessage tools
			andFormat: (anInputMessage hasFormats
					ifTrue: [ anInputMessage formatDescriptionsJsonSchema ]
					ifFalse: [ nil ])
			isStreaming: isStreaming.
	result hasToolCalls
		ifTrue: [ anotherMessage := self performToolCallsIn: result with: anInputMessage tools ]
		ifFalse: [ anOutputMessage := isStreaming
					ifTrue: [ self streamingMessageFrom: result ]
					ifFalse: [ self assistantMessageClass new
							modelName: self modelName;
							rawData: (result output detect: [ :anOutput | (anOutput at: 'type') = 'message' ]) ].
			self chat addAssistantMessage: anOutputMessage.
			self chat signalRunIsDone ].
	^ GtLOpenAIProviderProcessedMessage new
		inputMessage: anInputMessage;
		result: result;
		isStreaming: isStreaming;
		anotherProcessedMessage: anotherMessage;
		outputMessage: anOutputMessage
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> relevantChatMessages [
	| relevantMessages |
	relevantMessages := self chat messages
			messagesSelect: [ :each | each isAssistantRole and: [ each hasCompactionResponse ] ].
	^ relevantMessages isEmpty
		ifTrue: [ self chat messages ]
		ifFalse: [ self chat messages messagesWithAndAfter: relevantMessages last ]
]

{ #category : #utils }
GtLOpenAIProvider >> streamingMessageFrom: aResult [
	| aMessage |
	aResult provider: self.

	aMessage := self assistantMessageClass new
			role: 'assistant';
			model: self model;
			content: ''.
	aResult notifyOnOutput: aMessage.

	^ aMessage
]
