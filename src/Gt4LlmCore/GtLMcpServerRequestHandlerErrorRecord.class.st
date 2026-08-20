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
		priority: 3;
		object: [ self jsonRpc ];
		view: #gtRawFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect JSON RPC object'
			action: [ :anElement | anElement phlow spawnObject: self jsonRpc ]
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
