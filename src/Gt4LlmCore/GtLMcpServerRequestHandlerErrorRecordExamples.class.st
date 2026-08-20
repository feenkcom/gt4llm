"
Examples for GtLMcpServerRequestHandlerErrorRecord.
"
Class {
	#name : #GtLMcpServerRequestHandlerErrorRecordExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #examples }
GtLMcpServerRequestHandlerErrorRecordExamples >> basicJsonRpc [
	<gtExample>
	^ GtLMcpJsonRpc on: {'jsonrpc' -> '2.0'. 'id' -> 1. 'method' -> 'tools/list'} asDictionary
]

{ #category : #examples }
GtLMcpServerRequestHandlerErrorRecordExamples >> basicRequest [
	<gtExample>
	^ (ZnRequest post: '/') entity: (ZnEntity json: (STONJSON toString: {'jsonrpc' -> '2.0'. 'id' -> 1. 'method' -> 'tools/list'} asDictionary))
]

{ #category : #examples }
GtLMcpServerRequestHandlerErrorRecordExamples >> recordForDispatchError [
	<gtExample>
	<return: #GtLMcpServerRequestHandlerErrorRecord>
	| jsonRpc request response record |
	jsonRpc := self basicJsonRpc.
	request := self basicRequest.
	response := ZnResponse badRequest: request entity: (ZnEntity textCRLF: 'boom').
	record := [ 1 / 0 ]
		on: ZeroDivide
		do: [ :anError |
			GtLMcpServerRequestHandlerErrorRecord
				forException: anError
				jsonRpc: jsonRpc
				request: request
				response: response ].

	self assert: record exception class equals: ZeroDivide.
	self assert: record jsonRpc equals: jsonRpc.
	self assert: record rpcMethodDescription equals: 'tools/list'.
	self assert: record request equals: request.
	self assert: record response equals: response.

	^ record
]
