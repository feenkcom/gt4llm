Class {
	#name : #GtAnthropicProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'assistantWorking',
		'model',
		'client',
		'tools',
		'maxTokens',
		'instructions',
		'executions'
	],
	#category : #Gt4Anthropic
}

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> default [
	^ [ self withApiKeyFromFile ]
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> isConnectable [
	^ GtAnthropicClient apiKeyFile exists
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> providerName [
	^ 'Anthropic'
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtAnthropicClient apiKeyFileContents
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtAnthropicProvider >> client [
	^ client
]

{ #category : #accessing }
GtAnthropicProvider >> client: anObject [
	client := anObject
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> defaultAsssistantMessageClass [
	^ self chat messageClassForAnthropic
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> defaultMaxTokens [
	^ 4096
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> defaultModel [
	^ 'claude-3-7-sonnet-20250219'
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> defaultUserMessageClass [
	^ self chat messageClassForAnthropic
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> initialize [
	super initialize.

	assistantWorking := false.
	executions := OrderedCollection new.
	
	self initializeClient.
	
	tools := GtLlmToolsGroup new.
	maxTokens := self defaultMaxTokens.
	model := self defaultModel
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> initializeClient [
	client := GtAnthropicClient new
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> instructions [
	^ instructions
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtAnthropicProvider >> maxTokens [
	^ maxTokens
]

{ #category : #accessing }
GtAnthropicProvider >> maxTokens: anObject [
	maxTokens := anObject
]

{ #category : #accessing }
GtAnthropicProvider >> model [
	^ model
]

{ #category : #accessing }
GtAnthropicProvider >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtAnthropicProvider >> modelName [
	^ model
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> performToolCallsFor: aResult [
	aResult toolCalls
		do: [ :aToolCall | 
			| toolOutput |
			toolOutput := tools performToolCall: aToolCall.
			chat
				addMessage: (GtAnthropicToolMessage new
						id: aToolCall id;
						contentText: toolOutput) ]
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self model;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> sendAssistantMessage: aMessage [
	userMessageClass adoptInstance: aMessage.
	aMessage role: 'user'.
	self chat addMessage: aMessage.

	executions add: [ self triggerAssistant ] asAsyncPromise
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> sendFiles: aListOfFileReferences withMessage: aString [
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

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #accessing }
GtAnthropicProvider >> tools [
	^ tools
]

{ #category : #accessing }
GtAnthropicProvider >> tools: anObject [
	tools := anObject
]

{ #category : #'as yet unclassified' }
GtAnthropicProvider >> triggerAssistant [
	| result |
	assistantWorking := true.

	self chat signalRunHasStarted.

	[ result := self client
			completeChatWithModel: self model
			messages: self chat messages
			maxTokens: self maxTokens
			system: instructions
			andTools: tools.

	result
		content: ((result contentText removePrefix: '```json') removeSuffix: '```');
		model: self modelName.


	self chat addMessage: result.

	self performToolCallsFor: result ] doWhileTrue: [ result toolCalls isNotEmpty ].

	self chat signalRunIsDone.

	assistantWorking := false
]
