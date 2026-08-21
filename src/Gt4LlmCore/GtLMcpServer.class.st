Class {
	#name : #GtLMcpServer,
	#superclass : #Object,
	#instVars : [
		'port',
		'tools',
		'resources',
		'prompts',
		'server',
		'history',
		'errors',
		'debug',
		'asynchronous',
		'currentAsyncExecution',
		'objectStorage',
		'summarizersRegistry',
		'announcer'
	],
	#classVars : [
		'Current'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #accessing }
GtLMcpServer class >> current [
	^ Current
]

{ #category : #accessing }
GtLMcpServer class >> current: anMcpServer [
	Current := anMcpServer
]

{ #category : #accessing }
GtLMcpServer class >> resetCurrent [
	Current := nil
]

{ #category : #accessing }
GtLMcpServer >> addDefaultSummarizerSpecifications [
	^ summarizersRegistry addDefaultSpecifications
]

{ #category : #adding }
GtLMcpServer >> addPrompt: aPrompt [
	prompts add: aPrompt
]

{ #category : #'api - resources' }
GtLMcpServer >> addResource: aResource [
	resources add: aResource
]

{ #category : #adding }
GtLMcpServer >> addSummarizerClass: aClass [
	self addSummarizerSpecifications: {aClass asSpecification}
]

{ #category : #adding }
GtLMcpServer >> addSummarizerClasses: aCollection [
	self
		addSummarizerSpecifications: (aCollection collect: [ :each | each asSpecification ])
]

{ #category : #adding }
GtLMcpServer >> addSummarizerSpecification: aSpecification [
	summarizersRegistry addSpecification: aSpecification
]

{ #category : #adding }
GtLMcpServer >> addSummarizerSpecifications: aSpecification [
	summarizersRegistry addSpecifications: aSpecification
]

{ #category : #adding }
GtLMcpServer >> addTool: aTool [
	tools add: aTool
]

{ #category : #adding }
GtLMcpServer >> addTools: aToolList [
	tools addAll: aToolList
]

{ #category : #announcing }
GtLMcpServer >> announce: anAnnouncement [
	^ announcer
		ifNil: [ anAnnouncement ]
		ifNotNil: [ announcer announce: anAnnouncement ]
]

{ #category : #configuring }
GtLMcpServer >> beAsynchronous [
	asynchronous := true
]

{ #category : #configuring }
GtLMcpServer >> beSynchronous [
	asynchronous := false
]

{ #category : #public }
GtLMcpServer >> createAcceptedResponse [
	^ ZnResponse new
		statusLine: (ZnStatusLine new
				code: 202;
				reason: 'Accepted';
				version: 'HTTP/1.1');
		headers: (ZnHeaders new contentLength: 0);
		entity: (ZnByteArrayEntity bytes: ByteArray new);
		yourself
]

{ #category : #public }
GtLMcpServer >> createBadRequestResponseForError: anError fromRequest: request [
	| errorMessage |
	errorMessage := String streamContents: 
					[:out |
					out
						<< 'Bad Request ';
						<< request method;
						space.
					request uri printPathQueryFragmentOn: out.
					anError description
						ifNotNil: 
							[:anExceptionMessage |
							out
								<< '; ';
								<< anExceptionMessage]].
	^ZnResponse 
		badRequest: request 
		entity: (ZnEntity textCRLF: errorMessage)
]

{ #category : #private }
GtLMcpServer >> createInvalidRequestResponseForError: anError [
	"Answers a JSON-RPC 2.0 'Invalid Request' response (-32600): the request body parsed
	as JSON but is not a valid Request object (e.g. missing the required 'jsonrpc' or
	'method' field). id is null since no valid request id could be determined. Per
	JSON-RPC 2.0 (https://www.jsonrpc.org/specification#error_object) and MCP's Base
	Protocol error codes
	(https://modelcontextprotocol.io/specification/2026-07-28/basic/index#error-codes)."
	| reason |
	reason := (anError isKindOf: KeyNotFound)
		ifTrue: [ 'missing required field: ', anError key ]
		ifFalse: [ anError messageText ].
	reason ifNil: [ anError printString ].
	reason ifEmpty: [ anError printString ].
	^ ZnResponse
		ok: (ZnStringEntity
			json: (NeoJSONWriter toString:
				{'jsonrpc' -> '2.0'.
					'id' -> nil.
					'error'
						-> {'code' -> -32600.
							'message' -> 'Invalid Request'.
							'data' -> {'reason' -> reason} asDictionary}
							asDictionary}
					asDictionary))
]

{ #category : #private }
GtLMcpServer >> createMethodNotFoundResponseForJsonRpc: aJsonRpc [
	"Answers a JSON-RPC 2.0 error response using the standard 'Method not found' error
	code (-32601) for aJsonRpc, whose method name had no matching handler in
	#dispatchAllowingUnknownMethod:.

	MCP's Base Protocol requires every message to follow JSON-RPC 2.0
	(https://modelcontextprotocol.io/specification/2025-06-18/basic/index#messages),
	which states a response MUST set either 'result' or 'error', never both. -32601 is
	one of JSON-RPC 2.0's own pre-defined error codes
	(https://www.jsonrpc.org/specification#error_object); MCP re-exports it verbatim as
	METHOD_NOT_FOUND in its schema
	(https://github.com/modelcontextprotocol/specification/blob/main/schema/2025-06-18/schema.ts).

	This response shape also matters for the server/discover backward-compatibility probe
	(https://modelcontextprotocol.io/specification/2026-07-28/server/discover): a client
	probing an older/legacy server is expected to recognize this as 'method not supported'
	and fall back to the legacy initialize handshake, rather than choke on an opaque
	HTTP-level Bad Request."
	aJsonRpc isNotification ifTrue: [ ^ self createAcceptedResponse ].
	^ ZnResponse
		ok: (ZnStringEntity
			json: (NeoJSONWriter toString:
				{'jsonrpc' -> '2.0'.
					'id' -> aJsonRpc id.
					'error'
						-> {'code' -> -32601.
							'message' -> ('Method not found: ', aJsonRpc method asString)} asDictionary}
					asDictionary))
]

{ #category : #private }
GtLMcpServer >> createParseErrorResponseForError: anError [
	"Answers a JSON-RPC 2.0 'Parse error' response (-32700): the request body was not
	valid JSON at all. id is null since no request could be parsed. Per JSON-RPC 2.0
	(https://www.jsonrpc.org/specification#error_object) and MCP's Base Protocol, which
	uses the standard JSON-RPC 2.0 codes -32700/-32600..-32603 for general protocol
	failures (https://modelcontextprotocol.io/specification/2026-07-28/basic/index#error-codes)."
	^ ZnResponse
		ok: (ZnStringEntity
			json: (NeoJSONWriter toString:
				{'jsonrpc' -> '2.0'.
					'id' -> nil.
					'error'
						-> {'code' -> -32700.
							'message' -> 'Parse error'.
							'data' -> {'reason' -> anError messageText} asDictionary}
							asDictionary}
					asDictionary))
]

{ #category : #private }
GtLMcpServer >> createParseErrorResponseForNilContents [
	"Answers a JSON-RPC 2.0 'Parse error' response (-32700) for the case where the
	request has no body at all (aRequest contents is nil) - e.g. a bare GET/HEAD probe
	sent to the MCP endpoint with no JSON-RPC payload, as happens for connectivity
	checks such as 'claude mcp list'. There is nothing to parse, so this is treated the
	same as a Parse error rather than an Invalid Request (which assumes a JSON document
	was actually received). id is null since no request could be parsed. Per JSON-RPC
	2.0 (https://www.jsonrpc.org/specification#error_object) and MCP's Base Protocol,
	which uses the standard JSON-RPC 2.0 codes -32700/-32600..-32603 for general
	protocol failures
	(https://modelcontextprotocol.io/specification/2026-07-28/basic/index#error-codes)."
	^ ZnResponse
		ok: (ZnStringEntity
			json: (NeoJSONWriter toString:
				{'jsonrpc' -> '2.0'.
					'id' -> nil.
					'error'
						-> {'code' -> -32700.
							'message' -> 'Parse error'.
							'data' -> {'reason' -> 'Request body is empty'} asDictionary}
							asDictionary}
					asDictionary))
]

{ #category : #public }
GtLMcpServer >> createResponseForResult: aJsonRpcResult forRpc: aJsonRpc [
	aJsonRpc isNotification ifTrue: [ ^ self createAcceptedResponse ].

	^ ((GtLMcpJsonRpc new)
		id: aJsonRpc id;
		result: aJsonRpcResult) asZnResponse
]

{ #category : #utils }
GtLMcpServer >> createToolExecutionContext [
	^ GtLToolExecutionContext new 
			objectStorage: self objectStorage
]

{ #category : #handling }
GtLMcpServer >> detectToolNamed: aToolName [ 
	^tools 
		detect: [ :aTool | aTool name = aToolName]
		ifNone: [
				NotFound new 
					object: aToolName;
					messageText: 'Could not locate tool ', aToolName;
					signal ]
]

{ #category : #dispatching }
GtLMcpServer >> dispatch: jsonRpc [
	| camelCasedMethod selector |
	camelCasedMethod := (jsonRpc method
			ifNotNil: [ :aString | aString replaceAllRegex: '[^a-zA-Z]' with: ' ' ]
			ifNil: [ '' ]) asCamelCase asSymbol asMutator.
	selector := (#handle , camelCasedMethod) asSymbol.
	(self respondsTo: selector)
		ifFalse: [ ^ GtLMcpUnknownMethodError new
				rpcMethod: jsonRpc method;
				handleSelector: selector;
				signal ].
	^ self perform: selector withArguments: {jsonRpc}
]

{ #category : #accessing }
GtLMcpServer >> errorsSnapshot [
	^ errors lock: [ :aCollection | aCollection asArray ]
]

{ #category : #private }
GtLMcpServer >> executeAsyncRpc: aJsonRpc fromRequest: request [
	<return: #TAsyncPromise>
	| futureConfiguration futureComputation computationPromise errorHandlerPromise |

	futureComputation := [
		self dispatch: aJsonRpc ] asAsyncFuture.
	futureConfiguration := GtLAnthropicSettings futureExecutionConfiguration.
	self isDebug ifTrue: [
		futureComputation errorHandler: AsyncPassExceptionHandler new ].

	computationPromise := futureComputation
		await: futureConfiguration.

	errorHandlerPromise := computationPromise
			then: [ :aJsonRpcResult |
				self createResponseForResult: aJsonRpcResult forRpc: aJsonRpc ]
			otherwise: [ :anError |
				| errorResponse |
				errorResponse := (anError isKindOf: GtLMcpUnknownMethodError)
					ifTrue: [ self createMethodNotFoundResponseForJsonRpc: aJsonRpc ]
					ifFalse: [ self createBadRequestResponseForError: anError fromRequest: request ].
				self privateAddErrorRecord: (GtLMcpServerRequestHandlerErrorRecord
					forException: anError
					jsonRpc: aJsonRpc
					request: request
					response: errorResponse).
				errorResponse ].

	currentAsyncExecution := errorHandlerPromise.

	^ errorHandlerPromise wait
]

{ #category : #private }
GtLMcpServer >> executeSyncronouslyRpc: aJsonRpc fromRequest: request [
	<return: #TAsyncPromise>
	| jsonRpcResult response |
	[ jsonRpcResult := self dispatch: aJsonRpc ]
		on: Error
		do: [ :anError |
			| errorResponse |
			errorResponse := (anError isKindOf: GtLMcpUnknownMethodError)
				ifTrue: [ self createMethodNotFoundResponseForJsonRpc: aJsonRpc ]
				ifFalse: [ self createBadRequestResponseForError: anError fromRequest: request ].
			self privateAddErrorRecord: (GtLMcpServerRequestHandlerErrorRecord
				forException: anError
				jsonRpc: aJsonRpc
				request: request
				response: errorResponse).
			(anError isKindOf: GtLMcpUnknownMethodError) ifFalse: [
				self isDebug ifTrue: [ anError signal ] ].
			^ errorResponse ].

	response := self createResponseForResult: jsonRpcResult forRpc: aJsonRpc.
	^ response
]

{ #category : #finalization }
GtLMcpServer >> finalize [
	server ifNotNil: [ self stop ].

	super finalize
]

{ #category : #private }
GtLMcpServer >> getCapabilities [
	| capabilities |
	capabilities := {} asDictionary.

	tools ifNotEmpty: [ capabilities at: 'tools' put: {} asDictionary ].
	resources ifNotEmpty: [ capabilities at: 'resources' put: {} asDictionary ].
	prompts ifNotEmpty: [ capabilities at: 'prompts' put: {} asDictionary ].
	capabilities at: 'completions' put: {} asDictionary.

	^ capabilities
]

{ #category : #view }
GtLMcpServer >> gtErrorsFor: aView [
	<gtView>
	errors ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Errors';
		priority: 20;
		items: [ self errorsSnapshot reverse ];
		column: 'Created'
			text: [ :each | each createdAt asStringYMDHMS ]
			width: 130;
		column: 'Method' text: [ :each | each rpcMethodDescription ifNil: [ '' ] ];
		column: 'Error'
			text: [ :each | each errorReason ]
			weight: 3;
		updateWhen: GtLMcpServerErrorRecordAddedAnnouncement in: [ announcer ];
		actionUpdateButton
]

{ #category : #'gt-views' }
GtLMcpServer >> gtHistoryFor: aView [
	<gtView>
	
	history ifNil: [ ^ aView empty ].
	
	^ (aView columnedList)
		title: 'Executed tools';
		items: [ self historySnapshot reverse ];
		priority: 1;
		column: 'Role'
			text: [ :item | item role ]
			width: 70;
		column: 'Summary' text: [ :each | each contentOneLineSummary ];
		column: 'Created'
			text: [ :item | item createdAt asStringYMDHMS ]
			width: 130;
		column: 'Running'
			text: [ :item | item output ifNil: [ 'Yes' ] ifNotNil: [ '' ] ]
			width: 55;
		updateWhen: GtLMcpServerHistoryItemAddedAnnouncement in: [ announcer ];
		actionUpdateButton
]

{ #category : #views }
GtLMcpServer >> gtPromptsFor: aView [
	<gtView>
	prompts ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Prompts';
		priority: 1;
		object: [ prompts ];
		view: #gtPromptsFor:
]

{ #category : #'gt - extensions' }
GtLMcpServer >> gtResourcesFor: aView [
	<gtView>
	resources ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Resources';
		priority: 1;
		object: [ resources ];
		view: #gtResourcesFor:
]

{ #category : #views }
GtLMcpServer >> gtSummarizersRegistryFor: aView [
	<gtView>
	^ aView forward
		title: 'Summarizers';
		object: [ summarizersRegistry ];
		view: #gtCurrentSummarizersFor:
]

{ #category : #views }
GtLMcpServer >> gtToolsFor: aView [
	<gtView>
	tools ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Defined tools';
		priority: 50;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #'gt - extensions' }
GtLMcpServer >> gtViewObjectStorageFor: aView [
	<gtView>
	^(aView forward)
		title: 'Objects';
		priority: 15;
		object: [objectStorage];
		view: #gtObjectsByUUIDFor:;
		actionUpdateButton;
		actionButtonIcon: BrGlamorousVectorIcons bin
			tooltip: 'Wipe object storage clean'
			action: 
				[:aButton |
				objectStorage clearCache.
				aButton phlow fireViewUpdateWish]
]

{ #category : #handling }
GtLMcpServer >> handleCompletionComplete: aJsonRpc [
	^ {'completion'
			-> {'values' -> {}.
					'total' -> 0.
					'hasMore' -> false} asDictionary} asDictionary
]

{ #category : #'handling requests' }
GtLMcpServer >> handleInitialize: aJsonRpc [
	"Negotiates the protocol version per MCP's Version Negotiation
	(https://modelcontextprotocol.io/specification/2025-06-18/basic/lifecycle#version-negotiation):
	if the client's requested 'protocolVersion' is one #supportedProtocolVersions lists,
	the response MUST echo that same version back; otherwise the response MUST offer
	another version this server supports, which SHOULD be (and here is) the server's
	latest. This is not an error — the client decides whether to accept the offered
	version or disconnect."
	| requestedVersion negotiatedVersion |
	requestedVersion := aJsonRpc params at: 'protocolVersion'.
	negotiatedVersion := (self supportedProtocolVersions includes: requestedVersion)
		ifTrue: [ requestedVersion ]
		ifFalse: [ self supportedProtocolVersions first ].
	^ {'protocolVersion' -> negotiatedVersion.
		'capabilities' -> self getCapabilities.
		'serverInfo'
			-> {'name' -> 'Glamorous Toolkit'.
					'title' -> 'Glamorous Toolkit MCP Server'.
					'version' -> '1.0.0'} asDictionary.
		'instructions' -> ''} asDictionary
]

{ #category : #handling }
GtLMcpServer >> handleNotificationsCancelled: aJsonRpc [
	^ {} asDictionary
]

{ #category : #handling }
GtLMcpServer >> handleNotificationsInitialized: aJsonRpc [
	^ {} asDictionary
]

{ #category : #notifications }
GtLMcpServer >> handleNotificationsRootsListChanged: aJsonRpc [
	^ {} asDictionary
]

{ #category : #handling }
GtLMcpServer >> handlePromptsGet: aJsonRpc [
	| prompt |
	prompt := prompts
			detect: [ :aResource | aResource name = (aJsonRpc params at: 'name') ].
	^ {'description' -> prompt description.
		'messages'
			-> ((prompt callWith: (aJsonRpc params at: 'arguments')) collect: [:each | each serializeForAnthropicMessagesAPI])}
		asDictionary
]

{ #category : #handling }
GtLMcpServer >> handlePromptsList: aJsonRpc [
	^ {'prompts'
			-> (prompts
					collect: [ :aPrompt | 
						{'name' -> aPrompt name.
							'title' -> aPrompt name.
							'description' -> aPrompt description.
							'arguments'
								-> (aPrompt arguments
										collect: [ :anArgument | 
											{'name' -> anArgument.
												'description' -> anArgument.
												'required' -> true} asDictionary ])} asDictionary ]) asArray}
		asDictionary
]

{ #category : #'handling requests' }
GtLMcpServer >> handleRequest: aRequest [
	"Parses aRequest's body and dispatches it, distinguishing two ways a request can be
	malformed from a genuine handler error. Per MCP's Base Protocol, which uses the
	standard JSON-RPC 2.0 error codes for general protocol failures
	(https://modelcontextprotocol.io/specification/2026-07-28/basic/index#error-codes;
	see also https://www.jsonrpc.org/specification#error_object):
	- the body isn't valid JSON at all -> -32700 Parse error
		(#createParseErrorResponseForError:);
	- the body is valid JSON but not a valid Request object, e.g. missing the required
		'jsonrpc' or 'method' field -> -32600 Invalid Request
		(#createInvalidRequestResponseForError:).
	Once a GtLMcpJsonRpc is successfully built, dispatch continues via
	#executeAsyncRpc:fromRequest: / #executeSyncronouslyRpc:fromRequest:, which may in
	turn answer -32601 Method not found for a well-formed request naming an unknown
	method (#createMethodNotFoundResponseForJsonRpc:), or the existing generic Bad
	Request for any other in-handler error."

	| parsedBody jsonRpc response |
	[ | aContents |
	aRequest method = #GET ifTrue: [ ^ ZnResponse methodNotAllowed: aRequest ].
	aRequest method = #DELETE ifTrue: [ ^ ZnResponse methodNotAllowed: aRequest ].
	aRequest method = #POST ifFalse: [ ^ ZnResponse methodNotAllowed: aRequest ].

	aContents := aRequest contents.
	aContents
		ifNil: [ response := self createParseErrorResponseForNilContents.
			self
				privateAddErrorRecord: (GtLMcpServerEmptyRequestContentsErrorRecord
						forRequest: aRequest
						response: response).
			^ response ].
	parsedBody := STONJSON fromString: aContents ]
		on: Error
		do: [ :anError | 
			response := self createParseErrorResponseForError: anError.
			self
				privateAddErrorRecord: (GtLMcpServerRpcErrorRecord
						forException: anError
						request: aRequest
						response: response).
			^ response ].

	[ jsonRpc := GtLMcpJsonRpc on: parsedBody ]
		on: Error
		do: [ :anError | 
			response := self createInvalidRequestResponseForError: anError.
			self
				privateAddErrorRecord: (GtLMcpServerRpcErrorRecord
						forException: anError
						request: aRequest
						response: response).
			^ response ].

	^ self isAsynchronous
		ifTrue: [ self executeAsyncRpc: jsonRpc fromRequest: aRequest ]
		ifFalse: [ self executeSyncronouslyRpc: jsonRpc fromRequest: aRequest ]
]

{ #category : #handling }
GtLMcpServer >> handleResourcesList: aJsonRpc [
	^ {'resources'
			-> (resources
					collect: [ :aResource | 
						{'name' -> aResource name.
							'title' -> aResource name.
							'description' -> aResource description.
							'uri' -> aResource uri.
							'mimeType' -> aResource mimeType asString} asDictionary ]) asArray} asDictionary
]

{ #category : #handling }
GtLMcpServer >> handleResourcesRead: aJsonRpc [
	| resource |
	resource := resources
			detect: [ :aResource | aResource uri = (aJsonRpc params at: 'uri') ].
	^ {'contents'
			-> {{'name' -> resource name.
						'title' -> resource name.
						'uri' -> resource uri.
						'mimeType' -> resource mimeType asString.
						'text' -> resource contents} asDictionary}} asDictionary
]

{ #category : #handling }
GtLMcpServer >> handleResourcesTemplatesList: aJsonRpc [
	^ {'resourceTemplates' -> {}} asDictionary
]

{ #category : #'handling requests' }
GtLMcpServer >> handleServerDiscover: aJsonRpc [
	^ {'resultType' -> 'complete'.
		'supportedVersions' -> self supportedProtocolVersions.
		'capabilities' -> self getCapabilities.
		'_meta' -> {'io.modelcontextprotocol/serverInfo' -> self serverInfoForDiscovery} asDictionary.
		'instructions' -> ''} asDictionary
]

{ #category : #dispatching }
GtLMcpServer >> handleToolsCall: aJsonRpc [
	| tool result toolCall toolMessage |
	tool := self detectToolNamed: (aJsonRpc params at: 'name').
	toolCall := (GtLFunctionToolCall new)
				name: (aJsonRpc params at: 'name');
				rawArguments: (aJsonRpc params at: 'arguments').
	
	toolMessage := GtLToolMessage new 
		chat: (GtLMcpChatAdapter new server: self);
		toolCall: toolCall.
	self privateAddToolMessage: toolMessage.
	
	result := tool 
		performToolCall: toolCall 
		inContext: self createToolExecutionContext.
	toolMessage output: result.
	^
	{'isError' -> false.
	'content' -> result serializeForMCPResponseOutput}
			asDictionary
]

{ #category : #handling }
GtLMcpServer >> handleToolsList: aJsonRpc [
	^{'tools' -> (tools collect: [:aTool | aTool functionMCP]) asArray}
		asDictionary
]

{ #category : #accessing }
GtLMcpServer >> historySnapshot [
	^ history lock: [ :aHistory | aHistory asArray ]
]

{ #category : #initialization }
GtLMcpServer >> initialize [
	super initialize.
	port := 0.
	debug := false.
	asynchronous := true.
	tools := GtLTools new.
	resources := GtLMcpResources new.
	prompts := GtLMessagesGroup new.
	history := AsyncMutex for: OrderedCollection new.
	errors := AsyncMutex for: OrderedCollection new.
	objectStorage := GtLObjectStorage new.
	summarizersRegistry := GtLToolCallSummarizersRegistry new.
	announcer := Announcer new.
]

{ #category : #testing }
GtLMcpServer >> isAsynchronous [
	^asynchronous ifNil: [ true ]
]

{ #category : #testing }
GtLMcpServer >> isDebug [
	^ debug
]

{ #category : #testing }
GtLMcpServer >> isRunning [ 
	^ server notNil and: [
			server isRunning ]
]

{ #category : #accessing }
GtLMcpServer >> objectStorage [
	^objectStorage
]

{ #category : #'api - resources' }
GtLMcpServer >> pageObjectResource: aLepiterPage [
	| aPageUri aResource |
	aPageUri := 'lepage://' , aLepiterPage database properties databaseName , ':'
			, aLepiterPage title.

	aResource := GtLMcpResource new
			name: aLepiterPage title;
			uri: aPageUri;
			mimeType: ZnMimeType textPlain;
			contentsBlock: [ GtLLepiterContentExporter new
					page: aLepiterPage;
					export ].

	self addResource: aResource
]

{ #category : #'api - resources' }
GtLMcpServer >> pageResource: aPageName [
	self
		pageObjectResource: (LeDatabasesRegistry defaultLogicalDatabase pageNamed: aPageName)
]

{ #category : #accessing }
GtLMcpServer >> port [
	^ port
]

{ #category : #accessing }
GtLMcpServer >> port: anObject [
	port := anObject
]

{ #category : #private }
GtLMcpServer >> privateAddErrorRecord: anErrorRecord [
	| anAnnouncement |
	errors lock: [ :aCollection |
		aCollection add: anErrorRecord.
		anAnnouncement := GtLMcpServerErrorRecordAddedAnnouncement new
			mcpServer: self;
			errorRecord: anErrorRecord;
			yourself ].
	self announce: anAnnouncement
]

{ #category : #private }
GtLMcpServer >> privateAddToolMessage: aToolMessage [
	| anAnnouncement |
	history lock: [ :aHistory |
		aHistory add: aToolMessage.
		anAnnouncement := GtLMcpServerHistoryItemAddedAnnouncement new
			mcpServer: self;
			message: aToolMessage;
			yourself ].
	self announce: anAnnouncement
]

{ #category : #accessing }
GtLMcpServer >> prompts [
	^ prompts
]

{ #category : #finalization }
GtLMcpServer >> registerForFinalization [
	self class finalizationRegistry add: self
]

{ #category : #initialization }
GtLMcpServer >> resetTools [
	tools removeAll
]

{ #category : #accessing }
GtLMcpServer >> resources [
	^ resources
]

{ #category : #accessing }
GtLMcpServer >> server [
	^server
]

{ #category : #private }
GtLMcpServer >> serverInfoForDiscovery [
	^ {'name' -> 'Glamorous Toolkit'.
		'title' -> 'Glamorous Toolkit MCP Server'.
		'version' -> '1.0.0'} asDictionary
]

{ #category : #initialization }
GtLMcpServer >> setDebug [
	debug := true.
	server debugMode: true
]

{ #category : #actions }
GtLMcpServer >> start [
	server := ZnMultiThreadedServer new
		port: port;
		delegate: (ZnDispatcherDelegate new
				map: '/'
				to: [ :request :response | self handleRequest: request ]).
	server start.
	self registerForFinalization
]

{ #category : #actions }
GtLMcpServer >> stop [
	server
		ifNotNil: [server stop.
			server := nil]
]

{ #category : #private }
GtLMcpServer >> supportedProtocolVersions [
	"Answers the MCP protocol versions this server implements, newest first. Single
	source of truth shared by #handleInitialize: (version negotiation) and
	#handleServerDiscover: (supportedVersions). See
	https://modelcontextprotocol.io/specification/2025-06-18/basic/lifecycle#version-negotiation."
	^ #('2025-11-25' '2025-06-18')
]

{ #category : #accessing }
GtLMcpServer >> tools [
	^ tools
]

{ #category : #announcing }
GtLMcpServer >> unsubscribe: anObject [
	^ announcer
		ifNil: [ anObject ]
		ifNotNil: [ announcer unsubscribe: anObject ]
]

{ #category : #announcing }
GtLMcpServer >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass
		send: aSelector
		to: anObject
]
