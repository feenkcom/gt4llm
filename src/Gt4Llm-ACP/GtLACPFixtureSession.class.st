"
I supply an isolated MCP server to ACP summarizer examples without changing the image's current server.
"
Class {
	#name : #GtLACPFixtureSession,
	#superclass : #GtLACPSession,
	#instVars : [
		'mcpServer'
	],
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #accessing }
GtLACPFixtureSession >> mcpServer [
 ^ mcpServer
]

{ #category : #accessing }
GtLACPFixtureSession >> mcpServer: aServer [
 mcpServer := aServer
]

{ #category : #summaries }
GtLACPFixtureSession >> mcpToolMessages [
 ^ self mcpToolMessagesIn: mcpServer
]

{ #category : #summaries }
GtLACPFixtureSession >> mcpToolMessagesFor: toolCalls [
 ^ self mcpToolMessagesFor: toolCalls in: mcpServer
]

{ #category : #accessing }
GtLACPFixtureSession >> objectStorage [
 ^ mcpServer objectStorage
]
