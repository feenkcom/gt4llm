"
A Beacon signal emitted when the on-demand MCP server starts.
"
Class {
	#name : #GtLOnDemandMcpServerStartupSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'server'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #printing }
GtLOnDemandMcpServerStartupSignal >> printOneLineContentsOn: aStream [

	server ifNil:
		[ aStream << 'Started on-demand MCP server' ]
	ifNotNil:
		[ aStream
			<< 'Started on-demand MCP server on port: ';
			print: server port ].
]

{ #category : #accessing }
GtLOnDemandMcpServerStartupSignal >> server [
	^ server
]

{ #category : #accessing }
GtLOnDemandMcpServerStartupSignal >> server: aServer [
	server := aServer
]
