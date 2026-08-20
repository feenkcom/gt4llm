Class {
	#name : #GtLMcpServerExamples,
	#superclass : #Object,
	#instVars : [
		'recordedAnnouncement'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #utils }
GtLMcpServerExamples >> createBadRequestWithMessage: aMessage for: aRequest [
	|message|
	message := String streamContents: [ :out |
		out << 'Bad Request '; << aRequest method; space.
		aRequest uri printPathQueryFragmentOn: out.
		out << ('; ', aMessage) ].
	^ZnResponse 
			badRequest: aRequest
			entity: (ZnEntity textCRLF: message).
]

{ #category : #examples }
GtLMcpServerExamples >> handleInitializeEchoesSupportedProtocolVersion [
	<gtExample>
	| server jsonRpc result |
	server := GtLMcpServer new.
	jsonRpc := GtLMcpJsonRpc
		on: {'jsonrpc' -> '2.0'.
				'id' -> 1.
				'method' -> 'initialize'.
				'params' -> {'protocolVersion' -> '2025-06-18'} asDictionary} asDictionary.
	result := server handleInitialize: jsonRpc.
	self assert: (result at: 'protocolVersion') equals: '2025-06-18'.
	^ result
]

{ #category : #examples }
GtLMcpServerExamples >> handleInitializeNegotiatesUnsupportedProtocolVersion [
	<gtExample>
	| server jsonRpc result |
	server := GtLMcpServer new.
	jsonRpc := GtLMcpJsonRpc
		on: {'jsonrpc' -> '2.0'.
				'id' -> 1.
				'method' -> 'initialize'.
				'params' -> {'protocolVersion' -> '1999-01-01'} asDictionary} asDictionary.
	result := server handleInitialize: jsonRpc.
	self
		assert: (result at: 'protocolVersion')
		equals: server supportedProtocolVersions first.
	^ result
]

{ #category : #examples }
GtLMcpServerExamples >> handleRequestRecordsDispatchFailureAsynchronously [
	<gtExample>
	| server request response record |
	server := self serverWithTool.
	self assert: server isAsynchronous.
	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 1.
					'method' -> 'tools/call'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.
	self
		assert: response
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''name'' not found in Dictionary'
				for: request).
	record := server errorsSnapshot last.
	self assert: record class equals: GtLMcpServerRequestHandlerErrorRecord.
	self assert: record request equals: request.
	self assert: record response equals: response.
	self assert: record rpcMethodDescription equals: 'tools/call'.
	^ record
]

{ #category : #examples }
GtLMcpServerExamples >> handleRequestRecordsDispatchFailureSynchronously [
	<gtExample>
	| server request response record |
	server := self serverWithTool.
	server beSynchronous.
	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 1.
					'method' -> 'tools/call'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.
	self
		assert: response
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''name'' not found in Dictionary'
				for: request).
	record := server errorsSnapshot last.
	self assert: record class equals: GtLMcpServerRequestHandlerErrorRecord.
	self assert: record request equals: request.
	self assert: record response equals: response.
	self assert: record rpcMethodDescription equals: 'tools/call'.
	^ record
]

{ #category : #examples }
GtLMcpServerExamples >> handleRequestRecordsInvalidRequestFailure [
	<gtExample>
	| server request response record json |
	server := self simpleServer.
	request := self simpleServerRequest.
	response := server handleRequest: request.
	self assert: response statusLine code equals: 200.
	json := STONJSON fromString: response entity contents.
	self assert: ((json at: 'error') at: 'code') equals: -32600.
	self assert: ((json at: 'error') at: 'message') equals: 'Invalid Request'.
	record := server errorsSnapshot last.
	self assert: record class equals: GtLMcpServerRpcErrorRecord.
	self assert: record request equals: request.
	self assert: record response equals: response.
	self assert: record rpcMethodDescription isNil.
	^ record
]

{ #category : #examples }
GtLMcpServerExamples >> handleRequestRecordsParseError [
	<gtExample>
	| server request response record json |
	server := self simpleServer.
	request := self malformedJsonServerRequest.
	response := server handleRequest: request.
	self assert: response statusLine code equals: 200.
	json := STONJSON fromString: response entity contents.
	self assert: ((json at: 'error') at: 'code') equals: -32700.
	self assert: ((json at: 'error') at: 'message') equals: 'Parse error'.
	record := server errorsSnapshot last.
	self assert: record class equals: GtLMcpServerRpcErrorRecord.
	self assert: record request equals: request.
	self assert: record response equals: response.
	^ record
]

{ #category : #examples }
GtLMcpServerExamples >> handleRequestRecordsUnknownMethodFailureAsynchronously [
	<gtExample>
	| server request response record json |
	server := self simpleServer.
	self assert: server isAsynchronous.
	request := self
		serverRequestWithEntity: {'jsonrpc' -> '2.0'.
				'id' -> 1.
				'method' -> 'foo/bar'} asDictionary.
	response := server handleRequest: request.
	self assert: response statusLine code equals: 200.
	json := STONJSON fromString: response entity contents.
	self assert: ((json at: 'error') at: 'code') equals: -32601.
	self assert: ((json at: 'error') at: 'message') equals: 'Method not found: foo/bar'.
	record := server errorsSnapshot last.
	self assert: record class equals: GtLMcpServerRequestHandlerErrorRecord.
	self assert: record request equals: request.
	self assert: record response equals: response.
	self assert: record rpcMethodDescription equals: 'foo/bar'.
	^ record
]

{ #category : #examples }
GtLMcpServerExamples >> handleRequestRecordsUnknownMethodFailureSynchronously [
	<gtExample>
	| server request response record json |
	server := self simpleServer.
	server beSynchronous.
	request := self
		serverRequestWithEntity: {'jsonrpc' -> '2.0'.
				'id' -> 1.
				'method' -> 'foo/bar'} asDictionary.
	response := server handleRequest: request.
	self assert: response statusLine code equals: 200.
	json := STONJSON fromString: response entity contents.
	self assert: ((json at: 'error') at: 'code') equals: -32601.
	self assert: ((json at: 'error') at: 'message') equals: 'Method not found: foo/bar'.
	record := server errorsSnapshot last.
	self assert: record class equals: GtLMcpServerRequestHandlerErrorRecord.
	self assert: record request equals: request.
	self assert: record response equals: response.
	self assert: record rpcMethodDescription equals: 'foo/bar'.
	^ record
]

{ #category : #examples }
GtLMcpServerExamples >> jsonRpcNotificationDetection [
	<gtExample>
	| notification request |
	notification := GtLMcpJsonRpc
			on: {'jsonrpc' -> '2.0'.
					'method' -> 'tools/list'} asDictionary.

	self assert: notification id isNil.
	self assert: notification isNotification.

	request := GtLMcpJsonRpc
			on: {'jsonrpc' -> '2.0'.
					'id' -> 1.
					'method' -> 'tools/list'} asDictionary.

	self assert: request id equals: 1.
	self assert: request isNotification not.

	^ notification
]

{ #category : #examples }
GtLMcpServerExamples >> malformedJsonServerRequest [
	<gtExample>
	^ (ZnRequest post: '/') entity: (ZnEntity json: 'not valid json {')
]

{ #category : #support }
GtLMcpServerExamples >> recordAnnouncement: anAnnouncement [
	recordedAnnouncement := anAnnouncement
]

{ #category : #examples }
GtLMcpServerExamples >> serverAddsErrorRecordToErrors [
	<gtExample>
	| server errorRecord |
	server := self simpleServer.
	errorRecord := GtLMcpServerRpcErrorRecordExamples new recordForParseFailure.
	server privateAddErrorRecord: errorRecord.
	self assert: server errorsSnapshot last == errorRecord.
	^ errorRecord
]

{ #category : #examples }
GtLMcpServerExamples >> serverAddsToolMessageToHistory [
	<gtExample>
	| server toolMessage toolCall |
	server := self simpleServer.
	toolCall := GtLFunctionToolCall new
		name: 'Tool';
		rawArguments: Dictionary new.
	toolMessage := GtLToolMessage new toolCall: toolCall.
	server privateAddToolMessage: toolMessage.
	self assert: server historySnapshot last == toolMessage.
	^ toolMessage
]

{ #category : #examples }
GtLMcpServerExamples >> serverAnnouncesErrorRecordAdded [
	<gtExample>
	| server errorRecord |
	server := self simpleServer.
	errorRecord := GtLMcpServerRequestHandlerErrorRecordExamples new recordForDispatchError.
	recordedAnnouncement := nil.
	server
		when: GtLMcpServerErrorRecordAddedAnnouncement
		send: #recordAnnouncement:
		to: self.
	server privateAddErrorRecord: errorRecord.
	self assert: recordedAnnouncement notNil.
	self assert: recordedAnnouncement class equals: GtLMcpServerErrorRecordAddedAnnouncement.
	self assert: recordedAnnouncement mcpServer == server.
	self assert: recordedAnnouncement errorRecord == errorRecord.
	server unsubscribe: self.
	^ recordedAnnouncement
]

{ #category : #examples }
GtLMcpServerExamples >> serverAnnouncesHistoryItemAdded [
	<gtExample>
	| server toolMessage toolCall |
	server := self simpleServer.
	toolCall := GtLFunctionToolCall new
		name: 'Tool';
		rawArguments: Dictionary new.
	toolMessage := GtLToolMessage new toolCall: toolCall.
	recordedAnnouncement := nil.
	server
		when: GtLMcpServerHistoryItemAddedAnnouncement
		send: #recordAnnouncement:
		to: self.
	server privateAddToolMessage: toolMessage.
	self assert: recordedAnnouncement notNil.
	self assert: recordedAnnouncement class equals: GtLMcpServerHistoryItemAddedAnnouncement.
	self assert: recordedAnnouncement mcpServer == server.
	self assert: recordedAnnouncement message == toolMessage.
	server unsubscribe: self.
	^ recordedAnnouncement
]

{ #category : #examples }
GtLMcpServerExamples >> serverRequestWithEntity: anObject [
	^ (ZnRequest post: '/')
		entity: (ZnEntity json: (STONJSON toString: anObject))
]

{ #category : #examples }
GtLMcpServerExamples >> serverRespondsToServerDiscoverRequest [
	<gtExample>
	| server request response json result capabilities meta |
	server := self simpleServer.
	request := self
		serverRequestWithEntity: {'jsonrpc' -> '2.0'.
				'id' -> 1.
				'method' -> 'server/discover'} asDictionary.
	response := server handleRequest: request.
	self assert: response statusLine code equals: 200.
	json := STONJSON fromString: response entity contents.
	result := json at: 'result'.
	self assert: (result at: 'resultType') equals: 'complete'.
	self assert: (result at: 'supportedVersions') equals: #('2025-11-25' '2025-06-18').
	capabilities := result at: 'capabilities'.
	self assert: (capabilities includesKey: 'completions').
	meta := (result at: '_meta') at: 'io.modelcontextprotocol/serverInfo'.
	self assert: (meta at: 'name') equals: 'Glamorous Toolkit'.
	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithInitializedNotification [
	<gtExample>
	| server request response |
	server := self simpleServer.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'notifications/initialized'.
					'params' -> {} asDictionary} asDictionary.
	response := server handleRequest: request.

	self assert: response statusLine code equals: 202.
	self assert: response headers contentLength equals: 0.
	self assert: response entity contentLength equals: 0.

	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithPrompt [
	<gtExample>
	| server request response messageData |
	server := self simpleServer.

	server addPrompt: self simpleServerPrompt.

	self assert: server prompts size equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 1.
					'method' -> 'prompts/list'} asDictionary.
	response := server handleRequest: request.

	self
		assert: ((STONJSON fromString: response entity contents) at: 'result' at: 'prompts')
				size
		equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 2.
					'method' -> 'prompts/get'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''name'' not found in Dictionary'
				for: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 3.
					'method' -> 'prompts/get'.
					'params' -> {'name' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'NotFound: [ :aResource | aResource name = (aJsonRpc params at: ''name'') ] not found in OrderedCollection'
				for: request).


	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 4.
					'method' -> 'prompts/get'.
					'params'
						-> {'name' -> 'Prompt'.
								'arguments' -> {'argument' -> 'hello from prompt'} asDictionary}
								asDictionary} asDictionary.
	response := server handleRequest: request.

	messageData := (((STONJSON fromString: response entity contents) at: 'result' at: 'messages')
				first at: 'content') first.
	
	self
		assert: (messageData at: 'type')
		equals: 'text'.
		
		self
		assert: (((STONJSON fromString: (messageData at: 'text')) at: 'Markdown') at: 'content')		
		equals: 'hello from prompt'.

	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithResource [
	<gtExample>
	| server request response |
	server := self simpleServer.

	server addResource: self simpleServerResource.

	self assert: server resources size equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 1.
					'method' -> 'resources/list'} asDictionary.
	response := server handleRequest: request.

	self
		assert: ((STONJSON fromString: response entity contents) at: 'result' at: 'resources') size
		equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 2.
					'method' -> 'resources/read'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''uri'' not found in Dictionary'
				for: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 3.
					'method' -> 'resources/read'.
					'params' -> {'uri' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'NotFound: [ :aResource | aResource uri = (aJsonRpc params at: ''uri'') ] not found in OrderedCollection'
				for: request).


	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 4.
					'method' -> 'resources/read'.
					'params'
						-> {'uri' -> 'resource'}
								asDictionary} asDictionary.
	response := server handleRequest: request.

	self
		assert: (((STONJSON fromString: response entity contents) at: 'result' at: 'contents')
				first at: 'text')
		equals: 'hello from resource'.

	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithTool [
	<gtExample>
	| server |
	server := self simpleServer.
	server addTool: self simpleServerTool.
	self assert: server tools size equals: 1.
	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithToolCallHistoryAnnouncement [
	<gtExample>
	| server request response jsonResultContent |
	server := self serverWithTool.
	recordedAnnouncement := nil.
	server
		when: GtLMcpServerHistoryItemAddedAnnouncement
		send: #recordAnnouncement:
		to: self.
	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 2.
					'method' -> 'tools/call'.
					'params'
						-> {'name' -> 'Tool'.
								'arguments' -> {'param' -> 'hello from tool'} asDictionary}
								asDictionary} asDictionary.
	response := server handleRequest: request.
	jsonResultContent := (STONJSON fromString: response entity contents)
		at: 'result'
		at: 'content'.
	self assert: recordedAnnouncement notNil.
	self assert: recordedAnnouncement mcpServer == server.
	self assert: recordedAnnouncement message isToolMessage.
	self assert: (jsonResultContent first at: 'type') equals: 'text'.
	server unsubscribe: self.
	^ recordedAnnouncement
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithToolWithBadRequestAndResponse [
	<gtExample>
	| server request response |
	server := self serverWithTool.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 1.
					'method' -> 'tools/call'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.
	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''name'' not found in Dictionary'
				for: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 2.
					'method' -> 'tools/call'.
					'params' -> {'name' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.
	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'NotFound: Could not locate tool notFound'
				for: request).

	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithToolWithSuccessfulRequestAndResponse [
	<gtExample>
	| server request response jsonResultContent jsonResultTools |
	server := self serverWithTool.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 1.
					'method' -> 'tools/list'} asDictionary.
	response := server handleRequest: request.
	jsonResultTools := (STONJSON fromString: response entity contents)
			at: 'result'
			at: 'tools'.
	self assert: jsonResultTools size equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'id' -> 2.
					'method' -> 'tools/call'.
					'params'
						-> {'name' -> 'Tool'.
								'arguments' -> {'param' -> 'hello from tool'} asDictionary}
								asDictionary} asDictionary.
	response := server handleRequest: request.
	jsonResultContent := (STONJSON fromString: response entity contents)
			at: 'result'
			at: 'content'.
	self
		assert: (jsonResultContent first at: 'type')
		equals: 'text'.
	self
		assert: ((jsonResultContent first at: 'text')
			includesSubstring: 'hello from tool').

	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServer [
	<gtExample>
	| server simpleRequest response json |
	server := GtLMcpServer new.

	self assert: server port equals: 0.
	self assert: server isDebug not.

	simpleRequest := self simpleServerRequest.
	response := server handleRequest: simpleRequest.
	self assert: response statusLine code equals: 200.
	json := STONJSON fromString: response entity contents.
	self assert: ((json at: 'error') at: 'code') equals: -32600.
	self assert: ((json at: 'error') at: 'message') equals: 'Invalid Request'.
	self
		assert: (((json at: 'error') at: 'data') at: 'reason')
		equals: 'missing required field: jsonrpc'.

	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerPrompt [
	<gtExample>
	^ GtLMcpPrompt new
		name: 'Prompt';
		arguments: {'argument'};
		description: 'A prompt';
		promptBlock: [ :arguments | {GtLAnthropicUserMessage new 
			markdown: (arguments at: 'argument')} ]
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerRequest [
	<gtExample>
	^ self serverRequestWithEntity: {} asDictionary
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerResource [
	<gtExample>
	^ GtLMcpResource new
		name: 'Resource';
		description: 'A Resource';
		mimeType: ZnMimeType textPlain;
		uri: 'resource';
		contentsBlock: [ 'hello from resource' ]
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerTool [
	<gtExample>
	^ GtLFunctionTool new
		name: 'Tool';
		parameters: {'param'};
		description: 'A Tool';
		block: [  :functionCall |
			functionCall anyArgument ]
]
