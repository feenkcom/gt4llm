Class {
	#name : #GtLOllamaProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'client',
		'executions',
		'tools',
		'modelName',
		'instructions'
	],
	#category : 'Gt4Llm-Ollama-Provider'
}

{ #category : #'instance creation' }
GtLOllamaProvider class >> default [
	^ self new modelName: 'llama3.2'
]

{ #category : #testing }
GtLOllamaProvider class >> isConnectable [
	^ true
]

{ #category : #'instance creation' }
GtLOllamaProvider class >> openAiCompatibility [

	^ self new 
		configureForOpenAiCompatibility;
		modelName: 'llama3.2'
]

{ #category : #accessing }
GtLOllamaProvider class >> providerName [
	^ 'Ollama'
]

{ #category : #accessing }
GtLOllamaProvider >> addTool: aTool [
	tools := self tools copyWith: aTool
]

{ #category : #accessing }
GtLOllamaProvider >> client [
	^ client
]

{ #category : #private }
GtLOllamaProvider >> clientGenerateModelResponse: anInputMessage [
	^ self
		clientGenerateModelResponse: anInputMessage
		messages: self relevantChatMessages
]

{ #category : #private }
GtLOllamaProvider >> clientGenerateModelResponse: anInputMessage messages: someMessages [
	^ self client
		completeChatWithModel: self modelName
		andMessages: someMessages
		andFormat: (anInputMessage hasFormats
				ifTrue: [ anInputMessage formatDescriptionsJsonSchemaWithAllRequired ]
				ifFalse: [ nil ])
		andTools: anInputMessage tools
		andInstructions: anInputMessage instructions
]

{ #category : #'as yet unclassified' }
GtLOllamaProvider >> configureForGenerateApi [

	client := GtLOllamaGenerateClient new.
]

{ #category : #'as yet unclassified' }
GtLOllamaProvider >> configureForOpenAiCompatibility [

	client := GtLOllamaOpenAiClient new.
]

{ #category : #accessing }
GtLOllamaProvider >> defaultAssistantMessageClass [
	^ client assistantMessageClass
]

{ #category : #accessing }
GtLOllamaProvider >> defaultUserMessageClass [
	^ GtLOllamaUserMessage
]

{ #category : #api }
GtLOllamaProvider >> executeAsyncMessage: anInputMessage [
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
	executions add: errorHandlerPromise.
	^ errorHandlerPromise
]

{ #category : #private }
GtLOllamaProvider >> executeNextMessage: anInputMessage [
	| result |

	result := self clientGenerateModelResponse: anInputMessage.
	anInputMessage requestResponse: result requestResponse.
	^ result
]

{ #category : #accessing }
GtLOllamaProvider >> executions [
	^ executions
]

{ #category : #initialization }
GtLOllamaProvider >> initialize [
	super initialize.

	modelName := nil.
	self initializeClient.
	executions := OrderedCollection new.
	tools := #().
	instructions := ''
]

{ #category : #initialization }
GtLOllamaProvider >> initializeClient [
	client := GtLOllamaOpenAiClient new
]

{ #category : #accessing }
GtLOllamaProvider >> instructions [
	^ instructions ifNil: [ '' ]
]

{ #category : #accessing }
GtLOllamaProvider >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtLOllamaProvider >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLOllamaProvider >> modelName: aString [
	modelName := aString
]

{ #category : #private }
GtLOllamaProvider >> performToolCallsIn: result with: activeTools [
	| toolMessages |

	toolMessages := result toolCalls asArray
		withIndexCollect: [ :aToolCall :anIndex |
			| toolMessage domainObject |
			toolMessage := GtLToolMessage new
				toolCall: aToolCall;
				requestResponse: (GtLToolPreviousRequestResponse new
					previousRequestResponse: result requestResponse;
					toolCallIndex: anIndex).
			chat addToolMessage: toolMessage.
			self state
				ifCanContinue: [
					toolMessage beRunningExecutionState.
					[ domainObject := activeTools
						performToolCall: aToolCall
						inContext: self createToolExecutionContext.
					toolMessage output: domainObject ]
						ensure: [ toolMessage beFinishedExecutionState ] ]
				ifDisabled: [ toolMessage beSkippedExecutionState ].
			toolMessage ].
	self chat signalRunHasUpdated.
	toolMessages ifEmpty: [ ^ nil ].
	^ self processNextMessage: toolMessages last
]

{ #category : #printing }
GtLOllamaProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPutAll: ' (';
		nextPutAll: self modelName asString;
		nextPut: $)
]

{ #category : #private }
GtLOllamaProvider >> processNextMessage: anInputMessage [
	| result outputMessage anotherMessage |
	self state ifCanContinue: [ ] ifDisabled: [ ^ nil ].

	outputMessage := nil.
	anotherMessage := nil.
	result := self executeNextMessage: anInputMessage.
	result hasToolCalls
		ifTrue: [ anotherMessage := self performToolCallsIn: result with: anInputMessage tools ]
		ifFalse: [
			outputMessage := self
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

{ #category : #private }
GtLOllamaProvider >> relevantChatMessages [
	^ self chat messages
]

{ #category : #private }
GtLOllamaProvider >> responseTypeForResult: aResult fromInputMessage: anInputMessage [
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
GtLOllamaProvider >> tools [
	^ tools ifNil: [ #() ]
]

{ #category : #accessing }
GtLOllamaProvider >> tools: aCollection [
	tools := aCollection
]
