Class {
	#name : #GtMcpHttpTransport,
	#superclass : #Object,
	#instVars : [
		'url',
		'result',
		'sessionId'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtMcpHttpTransport >> client [
	| client |
	client := ZnClient new
			url: url;
			accept: 'application/json,text/event-stream';
			contentReader: [ :entity | 
				entity
					ifNil: [ {} ]
					ifNotNil: [ NeoJSONReader
							fromString: (entity contentType = 'application/json'
									ifTrue: [ entity contents ]
									ifFalse: [ (entity contents lines last: 2) first removePrefix: 'data: ' ]) ] ];
			contentWriter: [ :data | ZnEntity json: (NeoJSONWriter toString: data) ].

	sessionId ifNotNil: [ client headerAt: 'Mcp-Session-Id' put: sessionId ].

	^ client
]

{ #category : #'as yet unclassified' }
GtMcpHttpTransport >> receiveResponse [
	^ result
]

{ #category : #'as yet unclassified' }
GtMcpHttpTransport >> sendMessage: anObject [
	| client |
	client := self client contents: anObject.

	result := client post.

	client response headers
		at: 'Mcp-Session-Id'
		ifPresent: [ :aValue | sessionId := aValue ]
]

{ #category : #accessing }
GtMcpHttpTransport >> sessionId [
	^ sessionId
]

{ #category : #accessing }
GtMcpHttpTransport >> sessionId: anObject [
	sessionId := anObject
]

{ #category : #'as yet unclassified' }
GtMcpHttpTransport >> terminate [
]

{ #category : #'as yet unclassified' }
GtMcpHttpTransport >> url: anUrl [
	url := anUrl asZnUrl
]
