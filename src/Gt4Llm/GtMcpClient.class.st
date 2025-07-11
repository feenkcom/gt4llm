Class {
	#name : #GtMcpClient,
	#superclass : #Object,
	#instVars : [
		'messageId',
		'stdout',
		'serverCapabilities',
		'transport'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtMcpClient >> callTool: aString withArguments: anObject [
	^ (self
		sendMethod: 'tools/call'
		withParams: {'name' -> aString.
				'arguments' -> anObject} asDictionary) at: 'result' at: 'content'
]

{ #category : #'as yet unclassified' }
GtMcpClient >> gtCapabilitiesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Capabilities';
		priority: 1;
		items: [ serverCapabilities associations ];
		column: 'Capability' text: [ :aCapability | aCapability key ];
		column: 'Information' text: [ :aCapability | aCapability value ]
]

{ #category : #'as yet unclassified' }
GtMcpClient >> gtToolsFor: aView [
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
GtMcpClient >> initialize [
	super initialize.
	
	messageId := 0
]

{ #category : #'as yet unclassified' }
GtMcpClient >> initializeSession [
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
GtMcpClient >> listTools [
	^ (self sendMethod: 'tools/list' withParams: {} asDictionary)
		at: 'result'
		at: 'tools'
]

{ #category : #accessing }
GtMcpClient >> llmFunctionTools [
	^ self listTools
		collect: [ :aTool | 
			GtLlmFunctionTool new
				name: (aTool at: 'name');
				parameters: (aTool at: 'inputSchema' at: 'properties') keys;
				description: (aTool at: 'description');
				block: [ :functionCall | (self callTool: (aTool at: 'name') withArguments: functionCall arguments) asString ] ]
]

{ #category : #'as yet unclassified' }
GtMcpClient >> nextMessageId [
	messageId := messageId + 1.
	^ messageId
]

{ #category : #'as yet unclassified' }
GtMcpClient >> sendMethod: aString withParams: anObject [
	| content |
	content := {'jsonrpc' -> '2.0'.
					'id' -> self nextMessageId.
					'method' -> aString.
					'params' -> anObject} asDictionary.
	transport sendMessage: content.
	^ transport receiveResponse
]

{ #category : #accessing }
GtMcpClient >> terminateSession [
	process kill
]

{ #category : #accessing }
GtMcpClient >> transport [
	^ transport
]

{ #category : #accessing }
GtMcpClient >> transport: anObject [
	transport ifNotNil: [ transport terminate ].

	transport := anObject.

	self initializeSession
]
