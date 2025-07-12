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
		'errors'
	],
	#category : #'Gt4Llm-GToolkit'
}

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
GtMcpServer >> handleInitialize: aJsonRpc [
	^ {'protocolVersion' -> (aJsonRpc params at: 'protocolVersion').
		'capabilities' -> {'tools' -> {} asDictionary} asDictionary.
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
GtMcpServer >> handleRequest: request response: _ [
	| jsonRpc response jsonRpcResult |
	[ jsonRpc := GtMcpJsonRpc on: (STONJSON fromString: request entity contents) ]
		on: Error
		do: [ ^ ZnResponse badRequest: request ].

	[ jsonRpcResult := self dispatch: jsonRpc ]
		on: Error
		do: [ :anError | 
			errors add: anError freeze.
			^ ZnResponse badRequest: request ].

	response := (GtMcpJsonRpc new
			id: jsonRpc id;
			result: jsonRpcResult) asZnResponse.

	history add: request -> response.

	^ response
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
	tools := GtLlmToolsGroup new.
	resources := OrderedCollection new.
	prompts := OrderedCollection new.
	history := OrderedCollection new.
	errors := OrderedCollection new
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
GtMcpServer >> registerForFinalization [
	self class finalizationRegistry add: self
]

{ #category : #'as yet unclassified' }
GtMcpServer >> start [
	server := ZnMultiThreadedServer new
			port: port;
			delegate: (ZnDispatcherDelegate new map: '/' to: [ :request :response | self handleRequest: request response: response ]).

	server start.
	
	self registerForFinalization
]

{ #category : #'as yet unclassified' }
GtMcpServer >> stop [
	server
		ifNotNil: [ server stop.
			server := nil ]
]
