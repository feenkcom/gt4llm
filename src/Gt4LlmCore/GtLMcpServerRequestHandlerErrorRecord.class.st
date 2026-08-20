"
I am a GtLMcpServerErrorRecord capturing an error that occurred while GtLMcpServer dispatched an already-parsed GtLMcpJsonRpc (see #executeSyncronouslyRpc:fromRequest: and #executeAsyncRpc:fromRequest:). I additionally carry the jsonRpc being dispatched.
"
Class {
	#name : #GtLMcpServerRequestHandlerErrorRecord,
	#superclass : #GtLMcpServerErrorRecord,
	#instVars : [
		'jsonRpc'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #'instance creation' }
GtLMcpServerRequestHandlerErrorRecord class >> forException: anException jsonRpc: aJsonRpc request: aRequest response: aResponse [
	^ self new
		exception: (GtSystemUtility freeze: anException);
		jsonRpc: aJsonRpc;
		request: aRequest;
		response: aResponse;
		yourself
]

{ #category : #view }
GtLMcpServerRequestHandlerErrorRecord >> gtJsonRpcFor: aView [
	<gtView>
	self jsonRpc ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'JSON-RPC';
		priority: 0;
		object: [ self jsonRpc ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLMcpServerRequestHandlerErrorRecord >> jsonRpc [
	^ jsonRpc
]

{ #category : #accessing }
GtLMcpServerRequestHandlerErrorRecord >> jsonRpc: aJsonRpc [
	jsonRpc := aJsonRpc
]

{ #category : #accessing }
GtLMcpServerRequestHandlerErrorRecord >> rpcMethodDescription [
	^ self jsonRpc ifNotNil: [ :aJsonRpc | aJsonRpc method ]
]
