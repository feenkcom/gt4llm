Class {
	#name : #GtLModelProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'baseUrl',
		'authentication',
		'model',
		'compactionStrategy'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #testing }
GtLModelProvider class >> isConnectable [

	^ true
]

{ #category : #'instance creation' }
GtLModelProvider class >> withDefaultSetup [

	^ self new
]

{ #category : #compaction }
GtLModelProvider >> apiCompactionThreshold: anInteger [

	compactionStrategy := GtLApiCompactionStrategy forProvider: self.
	compactionStrategy thresholdTokensLimit: anInteger.
]

{ #category : #testing }
GtLModelProvider >> assistantMessageHasCompactionResponse: anAssistantMessage [
	"Answer a boolean indicating whether the provided message contains a compaction response.
	E.g. OpenAI will include an encrypted_content output for server-side compaction.
	To be removed."

	^ false
]

{ #category : #accessing }
GtLModelProvider >> authentication [
	^ authentication
]

{ #category : #accessing }
GtLModelProvider >> authentication: anObject [
	authentication := anObject
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> automaticCompactionMessagesFrom: aResult inputMessage: anInputMessage [
	"Answer automatic compaction messages produced by a provider response.
	By default, providers do not produce automatic compaction output."

	^ #()
]

{ #category : #accessing }
GtLModelProvider >> availableModels [
	| endpoint |

	endpoint := model endpointAt: 'availableModels'.
	^ endpoint resultFrom: (self client get: endpoint path).
]

{ #category : #accessing }
GtLModelProvider >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLModelProvider >> baseUrl: aZnUrl [

	baseUrl := aZnUrl.
	self client baseUrl: baseUrl.
]

{ #category : #accessing }
GtLModelProvider >> client [

	^ model client
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> clientGenerateModelResponse: anInputMessage [
	^ self
		clientGenerateModelResponse: anInputMessage
		messages: self relevantChatMessages
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> clientGenerateModelResponse: anInputMessage messages: someMessages [
	^ self client
		completeChatWithModel: model
		andMessages: someMessages
		andFormat: (anInputMessage hasFormats
				ifTrue: [ anInputMessage formatDescriptionsJsonSchemaWithAllRequired ]
				ifFalse: [ nil ])
		andTools: anInputMessage tools
		andInstructions: anInputMessage instructions instructionString
]

{ #category : #accessing }
GtLModelProvider >> compactionStrategy [
	^ compactionStrategy
]

{ #category : #accessing }
GtLModelProvider >> compactionStrategy: aCompactionStrategy [

	compactionStrategy := aCompactionStrategy.
	compactionStrategy provider: self.
]

{ #category : #endpoints }
GtLModelProvider >> completions [
	"Configure the receiver with an OpenAI completions endpoint"
	| chatEndpoint |

	chatEndpoint := GtLOllamaCompletionsEndpoint new
		reasoningValidator: self defaultOllamaCompletionsReasoningValidator.
	model endpointAt: 'userMessage' put: chatEndpoint.
	
	model
		optionAt: 'dataSourceRequestParser' put: (GtLDataSourceOpenAiCompletionsRequestParser new
			model: model);
		optionAt: 'dataSourceResponseParser' put: (GtLDataSourceOpenAiCompletionsResponseParser new
			model: model).
]

{ #category : #api }
GtLModelProvider >> createAPICompactionMessage [
	"Create the compaction message specified by the endpoint"

	^ model userMessageEndpoint createApiCompactionMessageForChat: self chat
]

{ #category : #api }
GtLModelProvider >> createEmbeddings: aStringOrCollection [

]

{ #category : #api }
GtLModelProvider >> createPromptCompactionMessage [
	"Create the compaction message specified by the endpoint"

	^ model userMessageEndpoint createPromptCompactionMessageForChat: self chat
]

{ #category : #accessing }
GtLModelProvider >> defaultAssistantMessageClass [
	^ model client assistantMessageClass
]

{ #category : #validators }
GtLModelProvider >> defaultOllamaCompletionsReasoningValidator [

	^ GtLModelReasoningValidator new
		noneValues: #(#none);
		reasoningValues: #(#low #medium #high).
]

{ #category : #validators }
GtLModelProvider >> defaultOllamaGenerateReasoningValidator [

	^ GtLModelReasoningValidator new
		noneValues: #(false #none);
		reasoningValues: #(true #low #medium #high).
]

{ #category : #accessing }
GtLModelProvider >> defaultUserMessageClass [

	^ GtLModelUserMessage
]

{ #category : #api }
GtLModelProvider >> deleteModel [
	| endpoint context requestResponse |

	endpoint := model endpointAt: 'deleteModel'.
	context := endpoint newContextForModel: model.
	context
		model: model;
		provider: self.
	requestResponse := self client
		delete: endpoint path
		withEntity: (endpoint entityFromContext: context)
		decodeResponse: false.
	^ endpoint resultFrom: requestResponse context: context.
]

{ #category : #'private - execution' }
GtLModelProvider >> ensureContextCompactionIfNeeded [

	compactionStrategy requestCompactionIfNeeded
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> executeAsyncMessage: anInputMessage [
	<return: #TAsyncPromise>
	| errorHandlerPromise aFuture firstPromise |
	self privateExecutionState: self state scheduled.
	aFuture := [
		self privateExecutionState: self state running.
		self ensureContextCompactionIfNeeded.
		self processNextMessage: anInputMessage ] asAsyncFuture.
	firstPromise := aFuture await: GtLOllamaSettings futureExecutionConfiguration.
	errorHandlerPromise := firstPromise
		then: [ :aProcessedMessage |
			self privateExecutionState: self state finished.
			self chat signalRunIsDone.
			aProcessedMessage ]
		otherwise: [ :anError |
			| aMessage |
			aMessage := GtLErrorMessage new
				freeze: anError;
				inputMessage: anInputMessage.
			self chat addErrorMessage: aMessage.
			self privateExecutionState: self state finished.
			self chat signalRunIsDone.
			aMessage ].
	"executions add: errorHandlerPromise."
	^ errorHandlerPromise
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> executeNextMessage: anInputMessage [
	| result |

	result := anInputMessage executionStrategy
		ifNil: [ self clientGenerateModelResponse: anInputMessage ]
		ifNotNil: [ :aMessageExecutionStrategy |
			aMessageExecutionStrategy executeMessage: anInputMessage with: self ].
	anInputMessage requestResponse: result requestResponse.
	^ result
]

{ #category : #endpoints }
GtLModelProvider >> generate [
	"Configure the receiver with an Ollama generate endpoint"
	| chatEndpoint |

	chatEndpoint := GtLOllamaGenerateEndpoint new
			reasoningValidator: self defaultOllamaGenerateReasoningValidator.
	model userMessageEndpoint: chatEndpoint.
	^ model.
]

{ #category : #ui }
GtLModelProvider >> gtViewCallsWithTokensFor: aView [
	<gtView>
	^(aView forward)
		title: 'API calls and tokens';
		priority: 1;
		object: [ self client];
		view: #gtViewCallsWithTokensFor:
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> initialize [

	super initialize.
	model := GtLLlmModel new.
	compactionStrategy := GtLNoCompactionStrategy new.
]

{ #category : #initialization }
GtLModelProvider >> loadApiKeyFromClipboard [

	self client loadApiKeyFromClipboard
]

{ #category : #initialization }
GtLModelProvider >> loadApiKeyFromFile [

	self client loadApiKeyFromFile
]

{ #category : #accessing }
GtLModelProvider >> model [
	^ model
]

{ #category : #accessing }
GtLModelProvider >> model: anObject [
	model := anObject
]

{ #category : #api }
GtLModelProvider >> modelDetails [
	| endpoint context requestResponse |

	endpoint := model endpointAt: 'modelDetails'.
	context := endpoint newContextForModel: model.
	context
		model: model;
		provider: self.
	requestResponse := self client
		post: endpoint path
		withEntity: (endpoint entityFromContext: context).
	^ endpoint resultFrom: requestResponse context: context.
]

{ #category : #accessing }
GtLModelProvider >> modelName [

	^ model name
]

{ #category : #accessing }
GtLModelProvider >> modelName: aString [

	model name: aString
]

{ #category : #private }
GtLModelProvider >> partitionAutomaticCompactionMessages: compactionMessages from: aResult inputMessage: anInputMessage [
	"Answer the automatic compaction messages split around the assistant output.
	The first element contains messages before the assistant output and the second
	contains messages after it. Providers whose responses do not expose this
	ordering keep all compaction messages before the assistant by default."

	^ { compactionMessages. #() }
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> performToolCallsIn: result with: activeTools [
	<return: #GtLOpenAIProviderProcessedMessage or: nil>
	| toolMessages |
	
	"self ensureContextCompactionIfNeeded."
	
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
						domainObject := activeTools 
							performToolCall: aToolCall
							inContext: (self createToolExecutionContext).
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

{ #category : #private }
GtLModelProvider >> processNextMessage: anInputMessage [
	| result outputMessage anotherMessage compactionMessages partitionedCompactionMessages preExecutionCompactionMessages postExecutionCompactionMessages |

	self state ifCanContinue: [ ] ifDisabled: [ ^ nil ].

	outputMessage := nil.
	anotherMessage := nil.
	result := self executeNextMessage: anInputMessage.

	compactionMessages := self
		automaticCompactionMessagesFrom: result
		inputMessage: anInputMessage.
	partitionedCompactionMessages := self
		partitionAutomaticCompactionMessages: compactionMessages
		from: result
		inputMessage: anInputMessage.
	preExecutionCompactionMessages := partitionedCompactionMessages first.
	postExecutionCompactionMessages := partitionedCompactionMessages second.
	preExecutionCompactionMessages do: [ :each |
		each updateDataFromMessage: anInputMessage.
		self chat addCompactionMessage: each ].

	result hasToolCalls
		ifTrue: [
			anotherMessage := self
				performToolCallsIn: result
				with: anInputMessage tools ]
		ifFalse: [
			outputMessage := self
				responseTypeForResult: result
				fromInputMessage: anInputMessage.
			self chat addAssistantMessage: outputMessage.
			postExecutionCompactionMessages do: [ :each |
				each updateDataFromMessage: anInputMessage.
				self chat addPostExecutionMessage: each ].
			self chat signalRunIsDone ].

	^ GtLOllamaProviderProcessedMessage new
		inputMessage: anInputMessage;
		result: result;
		anotherProcessedMessage: anotherMessage;
		outputMessage: outputMessage
]

{ #category : #api }
GtLModelProvider >> providerVersion [
	| endpoint |

	endpoint := model endpointAt: 'providerVersion'.
	^ (self client get: endpoint path) result at: 'version'.
]

{ #category : #api }
GtLModelProvider >> pullModel [
	| endpoint context requestResponse |

	endpoint := model endpointAt: 'pullModel'.
	context := endpoint newContextForModel: model.
	context
		model: model;
		provider: self.
	requestResponse := self client
		post: endpoint path
		withEntity: (endpoint entityFromContext: context).
	^ endpoint resultFrom: requestResponse context: context.
]

{ #category : #'private - accessing' }
GtLModelProvider >> relevantChatMessages [

	^ compactionStrategy relevantChatMessagesFor: self chat
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> responseTypeForResult: aResult fromInputMessage: anInputMessage [
	| newMessage |
	
	newMessage := anInputMessage isCompactionRequest ifTrue: 
		[ GtLModelCompactionMessage new ]
	ifFalse:
		[ self assistantMessageClass new ].

	newMessage initializeFromResult: aResult provider: self.

	^ newMessage
]

{ #category : #endpoints }
GtLModelProvider >> responses [
	"Configure the receiver with an OpenAI responses endpoint"
	| chatEndpoint |

	chatEndpoint := GtLOpenAiResponsesEndpoint new.
	model endpointAt: 'userMessage' put: chatEndpoint.

	model
		optionAt: 'dataSourceRequestParser' put: (GtLDataSourceOpenAiResponsesRequestParser new
			model: model);
		optionAt: 'dataSourceResponseParser' put: (GtLDataSourceOpenAiResponsesResponseParser new
			model: model).
		
	^ model
]

{ #category : #api }
GtLModelProvider >> runningModels [
	| endpoint |

	endpoint := model endpointAt: 'runningModels'.
	^ (self client get: endpoint path) result at: 'models'.
]
