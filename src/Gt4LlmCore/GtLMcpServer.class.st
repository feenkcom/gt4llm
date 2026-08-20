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
	| camelCasedMethod |
	camelCasedMethod := (jsonRpc method replaceAllRegex: '[^a-zA-Z]' with: ' ')
			asCamelCase asSymbol asMutator.
	^ self perform: (#handle , camelCasedMethod) asSymbol withArguments: {jsonRpc}
]

{ #category : #accessing }
GtLMcpServer >> errorsSnapshot [
	^ errors lock: [ :aCollection | aCollection asArray ]
]

{ #category : #requests }
GtLMcpServer >> executeAsyncRpc: aJsonRpc fromRequest: request [
	<return: #TAsyncPromise>
	| futureConfiguration futureComputation computationPromise errorHandlerPromise |

	futureComputation := [ 
		self dispatch: aJsonRpc ] asAsyncFuture.
	futureConfiguration := GtLAnthropicSettings futureExecutionConfiguration.
	self isDebug ifTrue: [
		futureComputation errorHandler: AsyncPassExceptionHandler new	].
	
	computationPromise := futureComputation 
		await: futureConfiguration.
	
	errorHandlerPromise := computationPromise
			then: [ :aJsonRpcResult |
				self createResponseForResult: aJsonRpcResult forRpc: aJsonRpc ]
			otherwise: [ :anError |
				| errorResponse |
				errorResponse := self createBadRequestResponseForError: anError fromRequest: request.
				self privateAddErrorRecord: (GtLMcpServerRequestHandlerErrorRecord
					forException: anError
					jsonRpc: aJsonRpc
					request: request
					response: errorResponse).
				errorResponse ].
			 
	currentAsyncExecution := errorHandlerPromise.
			 
	^errorHandlerPromise wait
]

{ #category : #requests }
GtLMcpServer >> executeSyncronouslyRpc: aJsonRpc fromRequest: request [
	<return: #TAsyncPromise>
	| jsonRpcResult response |
	[ jsonRpcResult := self dispatch: aJsonRpc ]
		on: Error
		do: [ :anError | 
			| errorResponse |
			errorResponse := self createBadRequestResponseForError: anError fromRequest: request.
			self privateAddErrorRecord: (GtLMcpServerRequestHandlerErrorRecord
				forException: anError
				jsonRpc: aJsonRpc
				request: request
				response: errorResponse).
			self isDebug ifTrue: [ anError signal ].
			^ errorResponse ].

	response := self createResponseForResult: jsonRpcResult forRpc: aJsonRpc.
	^ response
]

{ #category : #finalization }
GtLMcpServer >> finalize [
	server ifNotNil: [ self stop ].

	super finalize
]

{ #category : #accessing }
GtLMcpServer >> getCapabilities [
	| capabilities |
	capabilities := {} asDictionary.

	tools ifNotEmpty: [ capabilities at: 'tools' put: {} asDictionary ].
	resources ifNotEmpty: [ capabilities at: 'resources' put: {} asDictionary ].
	prompts ifNotEmpty: [ capabilities at: 'prompts' put: {} asDictionary ].

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

{ #category : #handling }
GtLMcpServer >> handleInitialize: aJsonRpc [
	^ {'protocolVersion' -> (aJsonRpc params at: 'protocolVersion').
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

{ #category : #requests }
GtLMcpServer >> handleRequest: aRequest [
	| jsonRpc response |
	[ jsonRpc := GtLMcpJsonRpc
			on: (STONJSON fromString: (aRequest contents ifNil: [ '{}' ])) ]
		on: Error
		do: [ :anError | 
			response := self createBadRequestResponseForError: anError fromRequest: aRequest.
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
