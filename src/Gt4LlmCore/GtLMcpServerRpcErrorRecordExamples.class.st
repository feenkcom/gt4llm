"
Examples for GtLMcpServerRpcErrorRecord.
"
Class {
	#name : #GtLMcpServerRpcErrorRecordExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #examples }
GtLMcpServerRpcErrorRecordExamples >> basicRequest [
	<gtExample>
	^ (ZnRequest post: '/') entity: (ZnEntity json: (STONJSON toString: Dictionary new))
]

{ #category : #examples }
GtLMcpServerRpcErrorRecordExamples >> recordForParseFailure [
	<gtExample>
	<return: #GtLMcpServerRpcErrorRecord>
	| request response record |
	request := self basicRequest.
	response := ZnResponse badRequest: request entity: (ZnEntity textCRLF: 'boom').
	record := [ STONJSON fromString: 'not-json' ]
		on: Error
		do: [ :anError |
			GtLMcpServerRpcErrorRecord
				forException: anError
				request: request
				response: response ].

	self assert: record exception notNil.
	self assert: record request equals: request.
	self assert: record response equals: response.
	self assert: record rpcMethodDescription isNil.
	self assert: record createdAt notNil.

	^ record
]
