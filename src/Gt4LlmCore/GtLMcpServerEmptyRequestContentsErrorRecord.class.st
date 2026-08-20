"
I am a GtLMcpServerErrorRecord capturing the case where GtLMcpServer>>#handleRequest: received a request with no body at all (aRequest contents answering nil) - e.g. a bare GET/HEAD probe with no JSON-RPC payload, as sent by 'claude mcp list' when checking reachability. Unlike GtLMcpServerRpcErrorRecord, there is no exception to carry - nothing was actually parsed - so #errorReason answers a fixed explanatory message instead.
"
Class {
	#name : #GtLMcpServerEmptyRequestContentsErrorRecord,
	#superclass : #GtLMcpServerErrorRecord,
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #'instance creation' }
GtLMcpServerEmptyRequestContentsErrorRecord class >> forRequest: aRequest response: aResponse [
	^ self new
		request: aRequest;
		response: aResponse;
		yourself
]

{ #category : #accessing }
GtLMcpServerEmptyRequestContentsErrorRecord >> errorReason [
	^ 'Request body is empty'
]

{ #category : #printing }
GtLMcpServerEmptyRequestContentsErrorRecord >> printOn: aStream [
	aStream nextPutAll: self class name; nextPutAll: ' ('.
	aStream nextPutAll: self errorReason.
	self rpcMethodDescription ifNotNil: [ :aMethod |
		aStream nextPutAll: ', '; nextPutAll: aMethod ].
	aStream nextPutAll: ')'
]
