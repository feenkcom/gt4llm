Class {
	#name : #GtLMcpServerAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'mcpServer'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMcpServerAnnouncement >> mcpServer [
	^ mcpServer
]

{ #category : #accessing }
GtLMcpServerAnnouncement >> mcpServer: anObject [
	mcpServer := anObject
]
