Class {
	#name : #GtLMcpClient,
	#superclass : #Object,
	#instVars : [
		'messageId',
		'stdout',
		'serverCapabilities',
		'transport'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #accessing }
GtLMcpClient >> callTool: aString withArguments: anObject [
	^ (self
		sendMethod: 'tools/call'
		withParams: {'name' -> aString.
				'arguments' -> anObject} asDictionary) at: 'result' at: 'content'
]

{ #category : #accessing }
GtLMcpClient >> getPrompt: aString withArguments: anObject [
	^ (self
		sendMethod: 'prompts/get'
		withParams: {'name' -> aString.
				'arguments' -> anObject} asDictionary) at: 'result'
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> gtCapabilitiesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Capabilities';
		priority: 1;
		items: [ serverCapabilities associations ];
		column: 'Capability' text: [ :aCapability | aCapability key ];
		column: 'Information' text: [ :aCapability | aCapability value ]
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> gtPromptsFor: aView [
	<gtView>
	(serverCapabilities includesKey: 'prompts') ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Prompts';
		priority: 2;
		items: [ self listPrompts ];
		column: 'Name' text: [ :aTool | aTool at: 'name' ];
		column: 'Description'
			text: [ :aTool | aTool at: 'description' ]
			weight: 3;
		column: 'Arguments'
			text: [ :aTool | 
				', '
					join: ((aTool at: 'arguments') collect: [ :anArgument | anArgument at: 'name' ]) ]
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> gtResourcesFor: aView [
	<gtView>
	(serverCapabilities includesKey: 'resources') ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Resources';
		priority: 2;
		items: [ self listResources ];
		column: 'Name' text: [ :aTool | aTool at: 'name' ];
		column: 'URI' text: [ :aTool | aTool at: 'uri' ] weight: 2;
		column: 'Description'
			text: [ :aTool | aTool at: 'description' ifAbsent: [ '' ] ]
			weight: 3
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> gtToolsFor: aView [
	<gtView>
	(serverCapabilities includesKey: 'tools') ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Tools';
		priority: 2;
		items: [ self listTools ];
		column: 'Name' text: [:aTool | aTool at: 'name' ];
		column: 'Description' text: [:aTool | aTool at: 'description' ] weight: 3
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> initialize [
	super initialize.
	
	messageId := 0.
	serverCapabilities := {} asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> initializeSession [
	| response |
	response := self
			sendMethod: 'initialize'
			withParams: {'protocolVersion' -> '2024-11-05'.
					'capabilities'
						-> {'roots' -> {} asDictionary.
								'sampling' -> {} asDictionary.
								'elicitation' -> {} asDictionary} asDictionary.
					'clientInfo'
						-> {'name' -> 'Glamorous Toolkit'.
								'title' -> 'Glamorous Toolkit LLM Integration'.
								'version' -> '1.0.0'} asDictionary} asDictionary.

	serverCapabilities := response at: 'result' at: 'capabilities'.

	transport
		sendMessage: {'jsonrpc' -> '2.0'. 'method' -> 'notifications/initialized'} asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> listPrompts [
	^ (self sendMethod: 'prompts/list' withParams: {} asDictionary)
		at: 'result'
		at: 'prompts'
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> listResources [
	^ (self sendMethod: 'resources/list' withParams: {} asDictionary)
		at: 'result'
		at: 'resources'
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> listTools [
	^ (self sendMethod: 'tools/list' withParams: {} asDictionary)
		at: 'result'
		at: 'tools'
]

{ #category : #accessing }
GtLMcpClient >> llmFunctionTools [
	^ self listTools
		collect: [ :aTool | 
			GtLlmFunctionTool new
				name: (aTool at: 'name');
				parameters: (aTool at: 'inputSchema' at: 'properties') keys;
				description: (aTool at: 'description');
				block: [ :functionCall | 
					STONJSON
						toString: (self callTool: (aTool at: 'name') withArguments: functionCall arguments) ] ]
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> messagesFromPrompt: aPromptName withArguments: anArgsDictionary [
	^ ((self getPrompt: aPromptName withArguments: anArgsDictionary) at: 'messages')
		collect: [ :aMessage | 
			GtLlmChatMessage new
				role: (aMessage at: 'role');
				content: (aMessage at: 'content' at: 'text') ]
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> nextMessageId [
	messageId := messageId + 1.
	^ messageId
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> readResource: aString [
	^ (self
		sendMethod: 'resources/read'
		withParams: {'uri' -> aString} asDictionary) at: 'result' at: 'contents'
]

{ #category : #'as yet unclassified' }
GtLMcpClient >> sendMethod: aString withParams: anObject [
	| content |
	content := {'jsonrpc' -> '2.0'.
					'id' -> self nextMessageId.
					'method' -> aString.
					'params' -> anObject} asDictionary.
	transport sendMessage: content.
	^ transport receiveResponse
]

{ #category : #accessing }
GtLMcpClient >> transport [
	^ transport
]

{ #category : #accessing }
GtLMcpClient >> transport: anObject [
	transport ifNotNil: [ transport terminate ].

	transport := anObject.

	self initializeSession
]
