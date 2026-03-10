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
		'debug'
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

{ #category : #'as yet unclassified' }
GtLMcpServer >> addPrompt: aPrompt [
	prompts add: aPrompt
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> addResource: aResource [
	resources add: aResource
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> addTools: aToolList [
	tools addAll: aToolList
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> dispatch: jsonRpc [
	| camelCasedMethod |
	camelCasedMethod := (jsonRpc method replaceAllRegex: '[^a-zA-Z]' with: ' ')
			asCamelCase asSymbol asMutator.
	^ self perform: (#handle , camelCasedMethod) asSymbol withArguments: {jsonRpc}
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> finalize [
	server ifNotNil: [ self stop ].

	super finalize
]

{ #category : #'as yet unclassified' }
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
		items: [errors];
		column: 'Value' text: [:each | each gtDisplayString]
]

{ #category : #views }
GtLMcpServer >> gtHistoryFor: aView [
	<gtView>
	history isEmptyOrNil ifTrue: [^aView empty].
	^(aView columnedList)
		title: 'History';
		priority: 5;
		items: [history];
		column: 'Tool use' text: [:each | each]
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> gtPromptsFor: aView [
	<gtView>
	prompts ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Prompts';
		priority: 1;
		object: [ prompts ];
		view: #gtPromptsFor:
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> gtResourcesFor: aView [
	<gtView>
	resources ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Resources';
		priority: 1;
		object: [ resources ];
		view: #gtResourcesFor:
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> gtToolsFor: aView [
	<gtView>
	tools ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Tools';
		priority: 1;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> handleCompletionComplete: aJsonRpc [
	^ {'completion'
			-> {'values' -> {}.
					'total' -> 0.
					'hasMore' -> false} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> handleInitialize: aJsonRpc [
	^ {'protocolVersion' -> (aJsonRpc params at: 'protocolVersion').
		'capabilities' -> self getCapabilities.
		'serverInfo'
			-> {'name' -> 'Glamorous Toolkit'.
					'title' -> 'Glamorous Toolkit MCP Server'.
					'version' -> '1.0.0'} asDictionary.
		'instructions' -> ''} asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> handleNotificationsInitialized: anObject [
	^ {} asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> handlePromptsGet: aJsonRpc [
	| prompt |
	prompt := prompts
			detect: [ :aResource | aResource name = (aJsonRpc params at: 'name') ].
	^ {'description' -> prompt description.
		'messages'
			-> ((prompt callWith: (aJsonRpc params at: 'arguments')) collect: #serialize)}
		asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> handlePromptsList: anObject [
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

{ #category : #'as yet unclassified' }
GtLMcpServer >> handleRequest: request [
	| jsonRpc response jsonRpcResult |
	[jsonRpc := GtLMcpJsonRpc on: (STONJSON fromString: request entity contents)]
		on: Error
		do: [^ZnResponse badRequest: request].
	[jsonRpcResult := self dispatch: jsonRpc] on: Error
		do: 
			[:anError |
			errors add: anError freeze.
			self isDebug ifTrue: [anError signal].
			^ZnResponse badRequest: request].
	response := ((GtLMcpJsonRpc new)
				id: jsonRpc id;
				result: jsonRpcResult) asZnResponse.
	^response
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
GtLMcpServer >> handleResourcesTemplatesList: aJsonRpc [
	^ {'resourceTemplates' -> {}} asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> handleToolsCall: aJsonRpc [
	| tool  output toolCall toolMessage |
	tool := tools detect: [:aTool | aTool name = (aJsonRpc params at: 'name')].
	toolCall := (GtLFunctionToolCall new)
				name: (aJsonRpc params at: 'name');
				arguments: (aJsonRpc params at: 'arguments').
	output := tool performToolCall: toolCall.
	toolMessage := GtLToolMessage new toolCall: toolCall.
	toolMessage output: output.
	history add: toolMessage.
	^
	{'isError' -> false.
	'content' -> output serializeToAnthropicResponseOutput}
			asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> handleToolsList: aJsonRpc [
	^{'tools' -> (tools collect: [:aTool | aTool functionAnthropic]) asArray}
		asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> initialize [
	port := 0.
	debug := false.
	tools := GtLTools new.
	resources := GtLOpenAIResourceFilesGroup new.
	prompts := GtLMessagesGroup new.
	history := OrderedCollection new.
	errors := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> isDebug [
	^ debug
]

{ #category : #accessing }
GtLMcpServer >> port [
	^ port
]

{ #category : #accessing }
GtLMcpServer >> port: anObject [
	port := anObject
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> prompts [
	^ prompts
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> registerForFinalization [
	self class finalizationRegistry add: self
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> resetTools [
	tools removeAll
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> resources [
	^ resources
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> server [
	^server
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> setDebug [
	debug := true.
	server debugMode: true
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> start [
	server := ZnMultiThreadedServer new
			port: port;
			delegate: (ZnDispatcherDelegate new
					map: '/'
					to: [ :request :response | self handleRequest: request ]).

	server start.

	self registerForFinalization
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> stop [
	server
		ifNotNil: [ server stop.
			server := nil ]
]

{ #category : #'as yet unclassified' }
GtLMcpServer >> tools [
	^ tools
]
