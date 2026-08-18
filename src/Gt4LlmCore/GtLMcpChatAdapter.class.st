Class {
	#name : #GtLMcpChatAdapter,
	#superclass : #Object,
	#instVars : [
		'server',
		'responseFormat'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #accessing }
GtLMcpChatAdapter >> currentFormat [
	^ responseFormat ifNil: [ responseFormat := GtLResponseCompositeFormat new ]
]

{ #category : #accessing }
GtLMcpChatAdapter >> currentTools [
	^ server tools
]

{ #category : #accessing }
GtLMcpChatAdapter >> instructions [
	^ #()
]

{ #category : #accessing }
GtLMcpChatAdapter >> objectStorage [
	^ self server objectStorage
]

{ #category : #accessing }
GtLMcpChatAdapter >> previousUserMessageIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ anAbsentBlock value
]

{ #category : #'as yet unclassified' }
GtLMcpChatAdapter >> provider [
	^ self
]

{ #category : #'as yet unclassified' }
GtLMcpChatAdapter >> serializeToolMessageForResponse: aGtLToolMessage [
	^ aGtLToolMessage output mainDataView serializeToLlmPrimiteData
		compositeJsonDataBlock llmJsonData
]

{ #category : #accessing }
GtLMcpChatAdapter >> server [
	^ server
]

{ #category : #accessing }
GtLMcpChatAdapter >> server: anObject [
	server := anObject
]
