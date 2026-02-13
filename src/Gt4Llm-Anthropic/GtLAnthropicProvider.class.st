Class {
	#name : #GtLAnthropicProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'client',
		'tools',
		'maxTokens',
		'instructions',
		'executions',
		'modelName'
	],
	#category : #'Gt4Llm-Anthropic-Provider'
}

{ #category : #'as yet unclassified' }
GtLAnthropicProvider class >> default [
	^ [ self withApiKeyFromFile ]
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider class >> isConnectable [
	^ GtAnthropicClient apiKeyFile exists
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider class >> providerName [
	^ 'Anthropic'
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtAnthropicClient apiKeyFileContents
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider class >> withDefaultSetup [
	^ self withApiKeyFromFile
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> addBrowseTool [
	self
		addTool: (GtLlmTool new
				type: 'web_search_20250305';
				name: 'web_search')
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtLAnthropicProvider >> client [
	^ client
]

{ #category : #accessing }
GtLAnthropicProvider >> client: anObject [
	client := anObject
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> defaultAssistantMessageClass [
	^ GtLAnthropicAssistantMessage
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> defaultMaxTokens [
	^ 4096
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> defaultUserMessageClass [
	^  GtLAnthropicUserMessage
]

{ #category : #actions }
GtLAnthropicProvider >> executeAsyncMessage: anInputMessage [
	<return: #TAsyncPromise>
	| errorHandlerPromise aFuture firstPromise |
	self privateExecutionState: self state scheduled.
	aFuture := [ 
		self privateExecutionState: self state running.
		self processNextMessage: anInputMessage ] asAsyncFuture.
	firstPromise := aFuture await: GtLAnthropicSettings futureExecutionConfiguration.
	errorHandlerPromise := firstPromise
			then: [ :aProcessedMessage | 
				self privateExecutionState: self state finished.
				self flag: #todo. "Remove signalRunIsDone"
				self chat signalRunIsDone.
				aProcessedMessage ]
			otherwise: [ :anError | 
				| aMessage |
				aMessage := GtLErrorMessage new
						freeze: anError;
						inputMessage: anInputMessage.
				self chat addErrorMessage: aMessage.
				self privateExecutionState: self state finished.
				self flag: #todo. "Remove signalRunIsDone"
				self chat signalRunIsDone.
				aMessage ].
	executions add: errorHandlerPromise.
	
	^ errorHandlerPromise
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> executions [
	^ executions
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Tools';
		priority: 5;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> gtViewCallsWithTokensFor: aView [
	<gtView>
	^(aView forward)
		title: 'API calls and tokens';
		priority: 1;
		object: [client];
		view: #gtViewCallsWithTokensFor:
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> initialize [
	super initialize.

	modelName := nil.	"set when the provider is built"
	
	self initializeClient.
	maxTokens := self defaultMaxTokens.
	executions := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> initializeClient [
	client := GtLAnthropicClient new
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> instructions [
	^ instructions
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtLAnthropicProvider >> maxTokens [
	^ maxTokens
]

{ #category : #accessing }
GtLAnthropicProvider >> maxTokens: anObject [
	maxTokens := anObject
]

{ #category : #accessing }
GtLAnthropicProvider >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLAnthropicProvider >> modelName: anObject [
	modelName := anObject
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> performToolCallsFor: aResult [
	aResult toolCalls
		do: [ :aToolCall | 
			| toolOutput |
			toolOutput := tools performToolCall: aToolCall.
			chat
				addMessage: (GtAnthropicToolMessage new
						id: aToolCall id;
						contentText: toolOutput) ]
]

{ #category : #'private - execution' }
GtLAnthropicProvider >> performToolCallsIn: result with: activeTools [
	<return: #GtLOpenAIProviderProcessedMessage or: nil>
	| toolMessages |
		
	toolMessages := result toolCalls asArray
			withIndexCollect: [ :aToolCall :anIndex | 
				| toolMessage |
				toolMessage := GtLToolMessage new 
					toolCall: aToolCall;
					requestResponse: (GtLToolPreviousRequestResponse new
						previousRequestResponse: result requestResponse;
						toolCallIndex: anIndex).
				chat addToolMessage: toolMessage.
				self state
					ifCanContinue: [ toolMessage beRunningExecutionState.
						[ |domainObject|
						domainObject := activeTools performToolCall: aToolCall.
						toolMessage output: domainObject ]
							ensure: [ toolMessage beFinishedExecutionState ] ]
					ifDisabled: [ toolMessage beSkippedExecutionState ].
				
				toolMessage ].
	self chat signalRunHasUpdated.
	
	"We send all chat messages, so it is enough to process just the last tool message.
	See: `GtLOpenAIGenerateResponseAPICommand>>#buildEntity`."
	toolMessages ifEmpty: [ ^ nil ].
	^ self processNextMessage: toolMessages last.
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self modelName;
		nextPut: $)
]

{ #category : #actions }
GtLAnthropicProvider >> processNextMessage: anInputMessage [
	<return: #GtLOpenAIProviderProcessedMessage or: nil>
	| result anOutputMessage anotherMessage |
	self state ifCanContinue: [ "continue" ] ifDisabled: [ ^ nil ].

	anOutputMessage := nil.
	anotherMessage := nil.
	result := client
			generateResponseWithModel: self modelName
			messages: self chat messages
			maxTokens: 4096
			instructions: anInputMessage completeInstructionString
			tools: anInputMessage tools
			andFormat: (anInputMessage hasFormats
					ifTrue: [ anInputMessage formatDescriptionsJsonSchema ]
					ifFalse: [ nil ]).

	result hasToolCalls
		ifTrue: [ anotherMessage := self performToolCallsIn: result with: anInputMessage tools ]
		ifFalse: [ anOutputMessage := self assistantMessageClass new
					modelName: self modelName;
					rawData: (result content) ].

	self chat addAssistantMessage: anOutputMessage.
	self chat signalRunIsDone.
	^ GtLAnthropicProviderProcessedMessage new
		inputMessage: anInputMessage;
		result: result;
		anotherProcessedMessage: anotherMessage;
		outputMessage: anOutputMessage
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> sendAssistantMessage: aMessage [
	self userMessageClass adoptInstance: aMessage.
	aMessage role: 'user'.
	self chat addMessage: aMessage.

	executions
		add: ([ self triggerAssistant ] asAsyncPromise
				then: [ 
					self privateExecutionState: self state finished. ]
				otherwise: [ :anError | 
					self privateExecutionState: self state finished.
					self chat
						addMessage: (GtLlmErrorThreadMessage new exception: anError freeze).
					self chat signalRunIsDone ])
]

{ #category : #'as yet unclassified' }
GtLAnthropicProvider >> sendFiles: aListOfFileReferences withMessage: aString [
	self
		sendAssistantMessage: (self userMessageClass new
				content: {{'type' -> 'text'.
							'text' -> aString} asDictionary}
						, (aListOfFileReferences
								collect: [ :aFileReference | 
									{'type' -> 'image'.
										'source'
											-> {'type' -> 'base64'.
													'media_type' -> 'image/jpeg'.
													'data' -> aFileReference binaryContents base64Encoded} asDictionary}
										asDictionary ]);
				role: 'user';
				chat: self)
]

{ #category : #accessing }
GtLAnthropicProvider >> tools [
	^ tools
]

{ #category : #accessing }
GtLAnthropicProvider >> tools: anObject [
	tools := anObject
]
