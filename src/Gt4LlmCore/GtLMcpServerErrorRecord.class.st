"
I am an abstract superclass capturing the context of one error encountered while GtLMcpServer processes an HTTP request: when it happened, the raw request and response, and the frozen exception.

I am not meant to be instantiated directly. See my concrete subclasses:
- GtLMcpServerRpcErrorRecord - used when the request body could not be parsed into a GtLMcpJsonRpc at all.
- GtLMcpServerRequestHandlerErrorRecord - used when dispatching an already-parsed GtLMcpJsonRpc failed.
"
Class {
	#name : #GtLMcpServerErrorRecord,
	#superclass : #Object,
	#instVars : [
		'createdAt',
		'request',
		'response',
		'exception'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #accessing }
GtLMcpServerErrorRecord >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> errorReason [
	^ self exception
		ifNotNil: [ :anException | anException messageText ]
		ifNil: [ '' ]
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> exception [
	^ exception
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> exception: anException [
	exception := anException
]

{ #category : #view }
GtLMcpServerErrorRecord >> gtExceptionFor: aView [
	<gtView>
	self exception ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Exception';
		priority: 1;
		object: [ self exception ];
		view: #gtLiveFor:
]

{ #category : #view }
GtLMcpServerErrorRecord >> gtRequestFor: aView [
	<gtView>
	self request ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Request';
		priority: 2;
		object: [ self request ];
		view: #gtLiveFor:
]

{ #category : #view }
GtLMcpServerErrorRecord >> gtResponseFor: aView [
	<gtView>
	self response ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Response';
		priority: 3;
		object: [ self response ];
		view: #gtLiveFor:
]

{ #category : #initialization }
GtLMcpServerErrorRecord >> initialize [
	super initialize.
	createdAt := DateAndTime now
]

{ #category : #printing }
GtLMcpServerErrorRecord >> printOn: aStream [
	aStream nextPutAll: self class name; nextPutAll: ' ('.
	self exception
		ifNotNil: [ :anException | aStream print: anException class ]
		ifNil: [ aStream nextPutAll: 'no exception' ].
	self rpcMethodDescription ifNotNil: [ :aMethod |
		aStream nextPutAll: ', '; nextPutAll: aMethod ].
	aStream nextPutAll: ')'
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> request [
	^ request
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> request: aRequest [
	request := aRequest
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> response [
	^ response
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> response: aResponse [
	response := aResponse
]

{ #category : #accessing }
GtLMcpServerErrorRecord >> rpcMethodDescription [
	"Answer a description of the JSON-RPC method being handled when the error occurred, or nil when no GtLMcpJsonRpc was available. Overridden by subclasses that carry a jsonRpc."

	^ nil
]
