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
		'objectStorage'
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

{ #category : #adding }
GtLMcpServer >> addPrompt: aPrompt [
	prompts add: aPrompt
]

{ #category : #adding }
GtLMcpServer >> addResource: aResource [
	resources add: aResource
]

{ #category : #adding }
GtLMcpServer >> addTool: aTool [
	tools add: aTool
]

{ #category : #adding }
GtLMcpServer >> addTools: aToolList [
	tools addAll: aToolList
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
	^((GtLMcpJsonRpc new)
				id: aJsonRpc id;
				result: aJsonRpcResult) asZnResponse.
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

{ #category : #public }
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
				errors add: anError.
				self 
					createBadRequestResponseForError:  anError 
					fromRequest: request  ].
					
	currentAsyncExecution := errorHandlerPromise.
			 
	^errorHandlerPromise wait
]

{ #category : #public }
GtLMcpServer >> executeSyncronouslyRpc: aJsonRpc fromRequest: request [
	<return: #TAsyncPromise>
	| jsonRpcResult response |
	
	[jsonRpcResult := self dispatch: aJsonRpc] on: Error
		do: 
			[:anError |
			errors add: anError freeze.
			self isDebug ifTrue: [anError signal].
			^ self 
					createBadRequestResponseForError:  anError 
					fromRequest: request ].
			
	response := self createResponseForResult: jsonRpcResult forRpc: aJsonRpc.
	^response
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

{ #category : #views }
GtLMcpServer >> gtErrorsFor: aView [
	<gtView>
	errors ifNil: [^aView empty].
	^(aView columnedList)
		title: 'Errors';
		priority: 20;
		items: [errors];
		column: 'Value' text: [:each | each gtDisplayString];
		actionUpdateButton
]

{ #category : #views }
GtLMcpServer >> gtHistoryFor: aView [
	<gtView>
	history ifNil: [^aView empty].
	^(aView columnedList)
		title: 'Logs';
		items: [history reverse];
		priority: 1;
		column: 'Role'
			text: [:item | item role]
			width: 70;
		column: 'Summary' text: [:each | each contentOneLineSummary];
		column: 'Created'
			text: [:item | item createdAt asStringYMDHMS]
			width: 130;
		column: 'Running'
			text: [:item | item output ifNil: ['Yes'] ifNotNil: ['']]
			width: 55;
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
GtLMcpServer >> gtScopesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Scopes';
		priority: 60;
		items: [self class availableScopes];
		column: 'Scope' text: [:each | each displayString];
		column: 'Status' text: [:each | (self class selectedScopes includes: each) ifTrue: ['Active'] ifFalse: ['']] width: 80;
		column: '' do: [:aColumn |
			aColumn
				width: 80;
				cellStencil: [BrButton new aptitude: BrGlamorousButtonWithLabelAptitude];
				dataBinder: [:aButton :aScope |
					aButton
						label: ((self class selectedScopes includes: aScope) ifTrue: ['Remove'] ifFalse: ['Add']);
						action: [
							(self class selectedScopes includes: aScope)
								ifTrue: [self class removeScope: aScope]
								ifFalse: [self class addScope: aScope].
							aButton phlow fireViewUpdateWish]]];
		actionUpdateButtonTooltip: 'Refresh scopes'
]

{ #category : #views }
GtLMcpServer >> gtToolsFor: aView [
	<gtView>
	tools ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Tools';
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
GtLMcpServer >> handleNotificationsInitialized: aJsonRpc [
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

{ #category : #public }
GtLMcpServer >> handleRequest: aRequest [
	| jsonRpc |
	
	[jsonRpc := GtLMcpJsonRpc on: (STONJSON fromString: aRequest entity contents)]
		on: Error
		do: [ :anError |
			^self 
					createBadRequestResponseForError:  anError 
					fromRequest: aRequest ].
	
	^self isAsynchronous 
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

{ #category : #handling }
GtLMcpServer >> handleToolsCall: aJsonRpc [
	| tool result toolCall toolMessage |
	tool := self detectToolNamed: (aJsonRpc params at: 'name').
	toolCall := (GtLFunctionToolCall new)
				name: (aJsonRpc params at: 'name');
				rawArguments: (aJsonRpc params at: 'arguments').
	
	toolMessage := GtLToolMessage new toolCall: toolCall.
	history add: toolMessage.
	
	result := tool 
		performToolCall: toolCall 
		inContext: self createToolExecutionContext.
	toolMessage output: result.
	^
	{'isError' -> false.
	'content' -> result serializeToAnthropicResponseOutput}
			asDictionary
]

{ #category : #handling }
GtLMcpServer >> handleToolsList: aJsonRpc [
	^{'tools' -> (tools collect: [:aTool | aTool functionAnthropic]) asArray}
		asDictionary
]

{ #category : #initialization }
GtLMcpServer >> initialize [
	super initialize.
	port := 0.
	debug := false.
	asynchronous := true.
	tools := GtLTools new.
	resources := GtLOpenAIResourceFilesGroup new.
	prompts := GtLMessagesGroup new.
	history := OrderedCollection new.
	errors := OrderedCollection new.
	objectStorage := GtLObjectStorage new.
]

{ #category : #testing }
GtLMcpServer >> isAsynchronous [
	^asynchronous ifNil: [ true ]
]

{ #category : #testing }
GtLMcpServer >> isDebug [
	^ debug
]

{ #category : #accessing }
GtLMcpServer >> objectStorage [
	^objectStorage
]

{ #category : #accessing }
GtLMcpServer >> port [
	^ port
]

{ #category : #accessing }
GtLMcpServer >> port: anObject [
	port := anObject
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
