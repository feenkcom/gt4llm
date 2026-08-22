"
GtLOnDemandMcpServer provides a process-wide MCP server that is created and started when its unique instance is first requested. It exposes the Glamorous Toolkit LLM tools over a dynamically allocated network port, allowing a remote MCP client to inspect and debug the running image. Cleaning the unique instance stops the underlying server.
"
Class {
	#name : #GtLOnDemandMcpServer,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'server',
		'port'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #'instance creation' }
GtLOnDemandMcpServer class >> onRemoveUniqueInstance: anInstance [
	anInstance onRemovedAsUniqueInstance
]

{ #category : #private }
GtLOnDemandMcpServer >> findAvailablePort [
	| socket |
	^ [ socket := Socket newTCP listenOn: 0.
		socket localPort ]
		ensure: [ socket ifNotNil: [ socket closeAndDestroy ] ]
]

{ #category : #initialization }
GtLOnDemandMcpServer >> initialize [
	super initialize.
	self start
]

{ #category : #testing }
GtLOnDemandMcpServer >> isRunning [
	^ server notNil and: [ server isRunning ]
]

{ #category : #accessing }
GtLOnDemandMcpServer >> objectStorage [
	^ server objectStorage
]

{ #category : #lifecycle }
GtLOnDemandMcpServer >> onRemovedAsUniqueInstance [
	self stop
]

{ #category : #accessing }
GtLOnDemandMcpServer >> port [
	^ port
]

{ #category : #accessing }
GtLOnDemandMcpServer >> server [
	^ server
]

{ #category : #starting }
GtLOnDemandMcpServer >> start [
	self isRunning ifTrue: [ ^ self ].
	port := self findAvailablePort.
	server := GtLMcpServer new
		port: port;
		addTools: GtLTools gt;
		start.
	GtLOnDemandMcpServerStartupSignal new
		server: self;
		emit.
	^ self
]

{ #category : #lifecycle }
GtLOnDemandMcpServer >> stop [
	server ifNotNil: [ server stop ].
	^ self
]
