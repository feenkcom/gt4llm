Class {
	#name : #GtLMcpHttpTransport,
	#superclass : #Object,
	#instVars : [
		'url',
		'result',
		'sessionId',
		'messages'
	],
	#category : 'Gt4LlmCore-Mcp'
}

{ #category : #'as yet unclassified' }
GtLMcpHttpTransport >> client [
	| client |
	client := ZnClient new
			url: url;
			accept: 'application/json,text/event-stream';
			contentReader: [ :entity | 
				entity
					ifNil: [ {} ]
					ifNotNil: [ NeoJSONReader
							fromString: (entity contentType asString = 'application/json'
									ifTrue: [ entity contents ]
									ifFalse: [ (entity contents lines last: 2) first removePrefix: 'data: ' ]) ] ];
			contentWriter: [ :data | ZnEntity json: (NeoJSONWriter toString: data) ].

	sessionId ifNotNil: [ client headerAt: 'Mcp-Session-Id' put: sessionId ].

	^ client
]

{ #category : #'as yet unclassified' }
GtLMcpHttpTransport >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ messages ];
		column: 'Method'
			text: [ :aMessage | aMessage at: 'method' ifAbsent: [ 'response' ] ];
		column: 'Body'
			text: [ :aMessage | aMessage ]
			weight: 3
]

{ #category : #'as yet unclassified' }
GtLMcpHttpTransport >> initialize [
	super initialize.
	
	messages := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtLMcpHttpTransport >> receiveResponse [
	messages add: result.
	^ result
]

{ #category : #'as yet unclassified' }
GtLMcpHttpTransport >> sendMessage: anObject [
	| client |
	client := self client contents: anObject.
	
	messages add: anObject.

	result := client post.

	client response headers
		at: 'Mcp-Session-Id'
		ifPresent: [ :aValue | sessionId := aValue ]
]

{ #category : #accessing }
GtLMcpHttpTransport >> sessionId [
	^ sessionId
]

{ #category : #accessing }
GtLMcpHttpTransport >> sessionId: anObject [
	sessionId := anObject
]

{ #category : #'as yet unclassified' }
GtLMcpHttpTransport >> terminate [
]

{ #category : #'as yet unclassified' }
GtLMcpHttpTransport >> url: anUrl [
	url := anUrl asZnUrl
]
