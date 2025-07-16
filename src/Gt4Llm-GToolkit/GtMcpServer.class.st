Class {
	#name : #GtMcpServer,
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
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtMcpServer >> addPrompt: aPrompt [
	prompts add: aPrompt
]

{ #category : #'as yet unclassified' }
GtMcpServer >> addResource: aResource [
	resources add: aResource
]

{ #category : #'as yet unclassified' }
GtMcpServer >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtMcpServer >> dispatch: jsonRpc [
	| camelCasedMethod |
	camelCasedMethod := (jsonRpc method replaceAllRegex: '[^a-zA-Z]' with: ' ')
			asCamelCase asSymbol asMutator.
	^ self perform: #handle , camelCasedMethod withArguments: {jsonRpc}
]

{ #category : #'as yet unclassified' }
GtMcpServer >> finalize [
	server ifNotNil: [ self stop ].

	super finalize
]

{ #category : #'as yet unclassified' }
GtMcpServer >> getCapabilities [
	| capabilities |
	capabilities := {} asDictionary.

	tools ifNotEmpty: [ capabilities at: 'tools' put: {} asDictionary ].
	resources ifNotEmpty: [ capabilities at: 'resources' put: {} asDictionary ].
	prompts ifNotEmpty: [ capabilities at: 'prompts' put: {} asDictionary ].

	^ capabilities
]

{ #category : #views }
GtMcpServer >> gtHistoryFor: aView [
	<gtView>
	history isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView columnedList
		title: 'History';
		priority: 5;
		items: [ history ];
		column: 'Request' text: [ :each | each key entity contents ];
		column: 'Response' text: [ :each | each value entity contents ]
]

{ #category : #'as yet unclassified' }
GtMcpServer >> gtPromptsFor: aView [
	<gtView>
	prompts ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Prompts';
		priority: 1;
		object: [ prompts ];
		view: #gtPromptsFor:
]

{ #category : #'as yet unclassified' }
GtMcpServer >> gtResourcesFor: aView [
	<gtView>
	resources ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Resources';
		priority: 1;
		object: [ resources ];
		view: #gtResourcesFor:
]

{ #category : #'as yet unclassified' }
GtMcpServer >> gtToolsFor: aView [
	<gtView>
	tools ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Tools';
		priority: 1;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handleCompletionComplete: aJsonRpc [
	^ {'completion'
			-> {'values' -> {}.
					'total' -> 0.
					'hasMore' -> false} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handleInitialize: aJsonRpc [
	^ {'protocolVersion' -> (aJsonRpc params at: 'protocolVersion').
		'capabilities' -> self getCapabilities.
		'serverInfo'
			-> {'name' -> 'Glamorous Toolkit'.
					'title' -> 'Glamorous Toolkit MCP Server'.
					'version' -> '1.0.0'} asDictionary.
		'instructions' -> ''} asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handleNotificationsInitialized: _ [
	^ {} asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handlePromptsGet: aJsonRpc [
	| prompt |
	prompt := prompts
			detect: [ :aResource | aResource name = (aJsonRpc params at: 'name') ].
	^ {'description' -> prompt description.
		'messages'
			-> ((prompt callWith: (aJsonRpc params at: 'arguments')) collect: #serialize)}
		asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handlePromptsList: _ [
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
GtMcpServer >> handleRequest: request [
	| jsonRpc response jsonRpcResult |
	[ jsonRpc := GtMcpJsonRpc on: (STONJSON fromString: request entity contents) ]
		on: Error
		do: [ ^ ZnResponse badRequest: request ].

	[ jsonRpcResult := self dispatch: jsonRpc ]
		on: Error
		do: [ :anError | 
			errors add: anError freeze.
			self isDebug ifTrue: [ anError signal ].
			^ ZnResponse badRequest: request ].

	response := (GtMcpJsonRpc new
			id: jsonRpc id;
			result: jsonRpcResult) asZnResponse.

	history add: request -> response.

	^ response
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handleResourcesList: _ [
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
GtMcpServer >> handleResourcesRead: aJsonRpc [
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
GtMcpServer >> handleResourcesTemplatesList: _ [
	^ {'resourceTemplates' -> {}} asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handleToolsCall: aJsonRpc [
	| tool |
	tool := tools detect: [ :aTool | aTool name = (aJsonRpc params at: 'name') ].
	^ {'isError' -> false.
		'content'
			-> {{'type' -> 'text'.
						'text'
							-> (tool
									performToolCall: (GtLlmFunctionToolCall new
											name: (aJsonRpc params at: 'name');
											arguments: (aJsonRpc params at: 'arguments')))} asDictionary}}
		asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServer >> handleToolsList: _ [
	^ {'tools'
			-> (tools
					collect: [ :aTool | 
						{'name' -> aTool name.
							'title' -> aTool name.
							'description' -> aTool description.
							'inputSchema'
								-> {'type' -> 'object'.
										'properties'
											-> (aTool parameters
													collect: [ :aString | 
														aString
															-> {'type' -> 'string'.
																	'description' -> aString} asDictionary ]) asDictionary.
										'required' -> aTool parameters} asDictionary} asDictionary ]) asArray}
		asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServer >> initialize [
	port := 0.
	debug := false.
	tools := GtLlmToolsGroup new.
	resources := GtMcpResourcesGroup new.
	prompts := GtMcpPromptsGroup new.
	history := OrderedCollection new.
	errors := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtMcpServer >> isDebug [
	^ debug
]

{ #category : #accessing }
GtMcpServer >> port [
	^ port
]

{ #category : #accessing }
GtMcpServer >> port: anObject [
	port := anObject
]

{ #category : #'as yet unclassified' }
GtMcpServer >> prompts [
	^ prompts
]

{ #category : #'as yet unclassified' }
GtMcpServer >> registerForFinalization [
	self class finalizationRegistry add: self
]

{ #category : #'as yet unclassified' }
GtMcpServer >> resources [
	^ resources
]

{ #category : #'as yet unclassified' }
GtMcpServer >> setDebug [
	debug := true.
	server debugMode: true
]

{ #category : #'as yet unclassified' }
GtMcpServer >> start [
	server := ZnMultiThreadedServer new
			port: port;
			delegate: (ZnDispatcherDelegate new
					map: '/'
					to: [ :request :response | self handleRequest: request ]).

	server start.

	self registerForFinalization
]

{ #category : #'as yet unclassified' }
GtMcpServer >> stop [
	server
		ifNotNil: [ server stop.
			server := nil ]
]

{ #category : #'as yet unclassified' }
GtMcpServer >> tools [
	^ tools
]
