"
I am signaled by GtLMcpServer>>#dispatchAllowingUnknownMethod: when a JSON-RPC request names a method for which no handler selector exists. Carries the raw method name in #rpcMethod.
"
Class {
	#name : #GtLMcpUnknownMethodError,
	#superclass : #Error,
	#instVars : [
		'rpcMethod',
		'handleSelector'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #accessing }
GtLMcpUnknownMethodError >> handleSelector [
	^ handleSelector
]

{ #category : #accessing }
GtLMcpUnknownMethodError >> handleSelector: anObject [
	handleSelector := anObject
]

{ #category : #accessing }
GtLMcpUnknownMethodError >> messageText [
	^ 'Unknown JSON-RPC method: ', (rpcMethod ifNil: [ 'nil' ])
]

{ #category : #accessing }
GtLMcpUnknownMethodError >> rpcMethod [
	^ rpcMethod
]

{ #category : #accessing }
GtLMcpUnknownMethodError >> rpcMethod: aString [
	rpcMethod := aString
]
