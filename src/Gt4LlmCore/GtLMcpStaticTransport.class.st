Class {
	#name : #GtLMcpStaticTransport,
	#superclass : #Object,
	#instVars : [
		'index',
		'messages'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #'as yet unclassified' }
GtLMcpStaticTransport >> addMessage: aMessage [
	messages add: aMessage
]

{ #category : #'as yet unclassified' }
GtLMcpStaticTransport >> initialize [
	super initialize.
	
	index := 0.
	messages := OrderedCollection new
]

{ #category : #accessing }
GtLMcpStaticTransport >> messages [
	^ messages
]

{ #category : #accessing }
GtLMcpStaticTransport >> messages: anObject [
	messages := anObject
]

{ #category : #'as yet unclassified' }
GtLMcpStaticTransport >> receiveResponse [
	index := index + 1.
	^ messages at: index ifAbsent: [ {} asDictionary ]
]

{ #category : #'as yet unclassified' }
GtLMcpStaticTransport >> sendMessage: aDict [
]
