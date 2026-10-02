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

{ #category : #accessing }
GtLOnDemandMcpServer class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new start ]
]

{ #category : #accessing }
GtLOnDemandMcpServer class >> uniqueInstanceOnPort: anInteger [

	(self hasUniqueInstance and: [ self uniqueInstance port ~= anInteger ]) ifTrue:
		[ self error: 'An instance on port ', self uniqueInstance port asString, ' already started' ].
	^ uniqueInstance ifNil: 
		[ uniqueInstance := self new
				port: anInteger;
				start ]
]

{ #category : #private }
GtLOnDemandMcpServer >> findAvailablePort [
	| socket |
	^ [ socket := Socket newTCP listenOn: 0.
		socket localPort ]
		ensure: [ socket ifNotNil: [ socket closeAndDestroy ] ]
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
	^ port ifNil: [ port := self findAvailablePort ]
]

{ #category : #accessing }
GtLOnDemandMcpServer >> port: anInteger [
	port := anInteger
]

{ #category : #accessing }
GtLOnDemandMcpServer >> server [
	^ server
]

{ #category : #starting }
GtLOnDemandMcpServer >> start [
	self isRunning ifTrue: [ ^ self ].
	server := GtLMcpServer new
		port: self port;
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
