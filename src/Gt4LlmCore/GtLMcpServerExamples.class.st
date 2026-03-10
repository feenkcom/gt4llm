Class {
	#name : #GtLMcpServerExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Mcp'
}

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> serverRequestWithEntity: anObject [
	^ (ZnRequest post: '/')
		entity: (ZnEntity json: (STONJSON toString: anObject))
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> serverWithPrompt [
	<gtExample>
	| server request response |
	server := self simpleServer.

	server addPrompt: self simpleServerPrompt.

	self assert: server prompts size equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'prompts/list'} asDictionary.
	response := server handleRequest: request.

	self
		assert: ((STONJSON fromString: response entity contents) at: 'result' at: 'prompts')
				size
		equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'prompts/get'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.

	self assert: response equals: (ZnResponse badRequest: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'prompts/get'.
					'params' -> {'name' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.

	self assert: response equals: (ZnResponse badRequest: request).


	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'prompts/get'.
					'params'
						-> {'name' -> 'Prompt'.
								'arguments' -> {'argument' -> 'hello from prompt'} asDictionary}
								asDictionary} asDictionary.
	response := server handleRequest: request.

	self
		assert: (((STONJSON fromString: response entity contents) at: 'result' at: 'messages')
				first at: 'content')
		equals: ((Array with: ((Dictionary new) 
			at: 'type' put: 'text';
			at:'text' put: '{
	"Markdown" : {
		"content" : "hello from prompt"
	}
}'; yourself))).

	^ server
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> serverWithResource [
	<gtExample>
	| server request response |
	server := self simpleServer.

	server addResource: self simpleServerResource.

	self assert: server resources size equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'resources/list'} asDictionary.
	response := server handleRequest: request.

	self
		assert: ((STONJSON fromString: response entity contents) at: 'result' at: 'resources') size
		equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'resources/read'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.

	self assert: response equals: (ZnResponse badRequest: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'resources/read'.
					'params' -> {'uri' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.

	self assert: response equals: (ZnResponse badRequest: request).


	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'resources/read'.
					'params'
						-> {'uri' -> 'resource'}
								asDictionary} asDictionary.
	response := server handleRequest: request.

	self
		assert: (((STONJSON fromString: response entity contents) at: 'result' at: 'contents')
				first at: 'text')
		equals: 'hello from resource'.

	^ server
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> serverWithTool [
	<gtExample>
	| server |
	server := self simpleServer.
	server addTool: self simpleServerTool.
	self assert: server tools size equals: 1.
	^ server
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> serverWithToolWithBadRequestAndResponse [
	<gtExample>
	| server request response |
	server := self serverWithTool.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'tools/call'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.
	self assert: response equals: (ZnResponse badRequest: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'tools/call'.
					'params' -> {'name' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.
	self assert: response equals: (ZnResponse badRequest: request).

	^ server
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> serverWithToolWithSuccessfulRequestAndResponse [
	<gtExample>
	| server request response jsonResultContent jsonResultTools |
	server := self serverWithTool.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'tools/list'} asDictionary.
	response := server handleRequest: request.
	jsonResultTools := (STONJSON fromString: response entity contents)
			at: 'result'
			at: 'tools'.
	self assert: jsonResultTools size equals: 1.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'tools/call'.
					'params'
						-> {'name' -> 'Tool'.
								'arguments' -> {'param' -> 'hello from tool'} asDictionary}
								asDictionary} asDictionary.
	response := server handleRequest: request.
	jsonResultContent := (STONJSON fromString: response entity contents)
			at: 'result'
			at: 'content'.
	self
		assert: (jsonResultContent first at: 'type')
		equals: 'text'.
	self
		assert: ((jsonResultContent first at: 'text')
			includesSubstring: 'hello from tool').

	^ server
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> simpleServer [
	<gtExample>
	| server simpleRequest |
	server := GtLMcpServer new.

	self assert: server port equals: 0.
	self assert: server isDebug not.

	simpleRequest := self simpleServerRequest.
	self
		assert: (server handleRequest: simpleRequest)
		equals: (ZnResponse badRequest: simpleRequest).

	^ server
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> simpleServerPrompt [
	<gtExample>
	^ GtLMcpPrompt new
		name: 'Prompt';
		arguments: {'argument'};
		description: 'A prompt';
		promptBlock: [ :arguments | {GtLAnthropicUserMessage new 
			markdown: (arguments at: 'argument')} ]
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> simpleServerRequest [
	<gtExample>
	^ self serverRequestWithEntity: {} asDictionary
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> simpleServerResource [
	<gtExample>
	^ GtLMcpResource new
		name: 'Resource';
		description: 'A Resource';
		mimeType: ZnMimeType textPlain;
		uri: 'resource';
		contentsBlock: [ 'hello from resource' ]
]

{ #category : #'as yet unclassified' }
GtLMcpServerExamples >> simpleServerTool [
	<gtExample>
	^ GtLFunctionTool new
		name: 'Tool';
		parameters: {'param'};
		description: 'A Tool';
		block: [  :functionCall |
			functionCall anyArgument ]
]
