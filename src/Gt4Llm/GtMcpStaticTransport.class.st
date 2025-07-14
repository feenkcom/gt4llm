Class {
	#name : #GtMcpStaticTransport,
	#superclass : #Object,
	#instVars : [
		'index',
		'messages'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtMcpStaticTransport >> addMessage: aMessage [
	messages add: aMessage
]

{ #category : #'as yet unclassified' }
GtMcpStaticTransport >> initialize [
	super initialize.
	
	index := 0.
	messages := OrderedCollection new
]

{ #category : #accessing }
GtMcpStaticTransport >> messages [
	^ messages
]

{ #category : #accessing }
GtMcpStaticTransport >> messages: anObject [
	messages := anObject
]

{ #category : #'as yet unclassified' }
GtMcpStaticTransport >> receiveResponse [
	index := index + 1.
	^ messages at: index ifAbsent: [ {} asDictionary ]
]

{ #category : #'as yet unclassified' }
GtMcpStaticTransport >> sendMessage: aDict [
]
