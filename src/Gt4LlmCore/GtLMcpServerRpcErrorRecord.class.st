"
I am a GtLMcpServerErrorRecord capturing an error that occurred in GtLMcpServer>>#handleRequest: before a GtLMcpJsonRpc could be built - typically because the request body was not valid JSON-RPC. Since no GtLMcpJsonRpc exists yet, I only carry the raw request/response and the frozen exception.
"
Class {
	#name : #GtLMcpServerRpcErrorRecord,
	#superclass : #GtLMcpServerErrorRecord,
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #'instance creation' }
GtLMcpServerRpcErrorRecord class >> forException: anException request: aRequest response: aResponse [
	^ self new
		exception: (GtSystemUtility freeze: anException);
		request: aRequest;
		response: aResponse;
		yourself
]
