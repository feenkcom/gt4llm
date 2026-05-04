Class {
	#name : #GtLModelProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'baseUrl',
		'authentication',
		'model'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLModelProvider >> authentication [
	^ authentication
]

{ #category : #accessing }
GtLModelProvider >> authentication: anObject [
	authentication := anObject
]

{ #category : #accessing }
GtLModelProvider >> availableModels [
	| endpoint modelsArray |

	endpoint := model endpointAt: 'availableModels'.
	modelsArray := (self client get: endpoint path) result at: 'models'.
	^ modelsArray groupedBy: 
		[ :modelDetails | modelDetails at: 'name' ].
]

{ #category : #accessing }
GtLModelProvider >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLModelProvider >> baseUrl: anObject [
	baseUrl := anObject
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

{ #category : #'as yet unclassified' }
GtLModelProvider >> defaultAssistantMessageClass [
	^ model client assistantMessageClass
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> executeAsyncMessage: anInputMessage [
	<return: #TAsyncPromise>
	| errorHandlerPromise aFuture firstPromise |
	self privateExecutionState: self state scheduled.
	aFuture := [
		self privateExecutionState: self state running.
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

{ #category : #accessing }
GtLModelProvider >> model [
	^ model
]

{ #category : #accessing }
GtLModelProvider >> model: anObject [
	model := anObject
]

{ #category : #accessing }
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

{ #category : #'as yet unclassified' }
GtLModelProvider >> processNextMessage: anInputMessage [
	| result outputMessage anotherMessage |
	
	self state ifCanContinue: [ ] ifDisabled: [ ^ nil ].

	outputMessage := nil.
	anotherMessage := nil.
	result := self executeNextMessage: anInputMessage.
	result hasToolCalls
		ifTrue: [ anotherMessage := self performToolCallsIn: result with: anInputMessage tools ]
		ifFalse: 
			[ outputMessage := self
				responseTypeForResult: result
				fromInputMessage: anInputMessage.
			self chat addAssistantMessage: outputMessage.
			self chat signalRunIsDone ].

	^ GtLOllamaProviderProcessedMessage new
		inputMessage: anInputMessage;
		result: result;
		anotherProcessedMessage: anotherMessage;
		outputMessage: outputMessage
]

{ #category : #accessing }
GtLModelProvider >> providerVersion [
	| endpoint |

	endpoint := model endpointAt: 'providerVersion'.
	^ (self client get: endpoint path) result at: 'version'.
]

{ #category : #'private - accessing' }
GtLModelProvider >> relevantChatMessages [
	^ self chat messages
]

{ #category : #'as yet unclassified' }
GtLModelProvider >> responseTypeForResult: aResult fromInputMessage: anInputMessage [
	| newMessage |
	newMessage := self assistantMessageClass new.
	newMessage
		requestResponse: aResult requestResponse;
		rawData: aResult rawData.
	anInputMessage isCompactionRequest ifTrue: [
		newMessage markWithCompactionResponse ].
	^ newMessage
]

{ #category : #accessing }
GtLModelProvider >> runningModels [
	| endpoint |

	endpoint := model endpointAt: 'runningModels'.
	^ (self client get: endpoint path) result at: 'models'.
]
