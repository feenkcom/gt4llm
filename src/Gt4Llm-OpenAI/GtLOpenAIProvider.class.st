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

{ #category : #actions }
GtLOpenAIProvider >> executeWait [
	| aSecondPromise aFuture aFirstPromise |
	aFuture := [ | result aMessage currentMessage |
		currentMessage := self chat messages last currentMessage.
		result := client
				generateResponseWithModel: self modelName
				messages: self chat messages
				instructions: currentMessage completeInstructionString
				tools: currentMessage tools
				andFormat: (currentMessage hasFormats
						ifTrue: [ currentMessage formatDescriptionsJsonSchema ]
						ifFalse: [ nil ])
				isStreaming: isStreaming.

		result hasToolCalls
			ifTrue: [ self performToolCallsIn: result with: currentMessage tools ]
			ifFalse: [ aMessage := isStreaming
						ifTrue: [ self streamingMessageFrom: result ]
						ifFalse: [ self assistantMessageClass new
								modelName: self modelName;
								rawData: (result output detect: [ :anOutput | (anOutput at: 'type') = 'message' ]) ].

				self chat addAssistantMessage: aMessage.
				self chat signalRunIsDone.
				aMessage ] ] asAsyncFuture.
	aFirstPromise := aFuture
			await: (AsyncFutureExecutionConfiguration new
					customGroup: #OpenAI;
					lowPriority).
	aSecondPromise := aFirstPromise
			then: [ :aMessage |
				providerWorking := false.
				aMessage ]
			otherwise: [ :anError | 
				| aMessage |
				providerWorking := false.
				aMessage := GtLErrorMessage freeze: anError.
				self chat addErrorMessage: aMessage.
				self chat signalRunIsDone.
				aMessage ].
	executions add: aSecondPromise.
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

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> handleToolCall: aToolCall [
	| toolOutput newMessage |
	chat removeLastMessage.
	newMessage := GtLToolMessage new toolCall: aToolCall.
	chat addToolMessage: newMessage.
	toolOutput := tools performToolCall: aToolCall.
	newMessage output: toolOutput.
	self chat signalRunHasUpdated.
	^ self executeWait
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> initialize [
	super initialize.
	modelName := nil.	"set when the provider is built"
	providerWorking := false.
	client := GtLOpenAIClient new.
	executions := OrderedCollection new.
	isStreaming := true
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
	| toolOutputs |
	
	toolOutputs := result toolCalls
			collect: [ :aToolCall | 
				| newMessage|
				newMessage := GtLToolMessage new
							toolCall: aToolCall.
				chat addToolMessage: newMessage.
				newMessage beRunningExecutionState.
				[ |domainObject|
					domainObject := activeTools performToolCall: aToolCall.
					newMessage output: domainObject ]
					ensure: [ newMessage beFinishedExecutionState ] ].
	self chat signalRunHasUpdated.
	^ self executeWait
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self modelName;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> status [
	^ providerWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
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
