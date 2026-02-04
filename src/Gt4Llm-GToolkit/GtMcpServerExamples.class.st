Class {
	#name : #GtMcpServerExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-GToolkit-Mcp'
}

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> serverRequestWithEntity: anObject [
	^ (ZnRequest post: '/')
		entity: (ZnEntity json: (STONJSON toString: anObject))
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> serverWithPrompt [
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
		equals: 'hello from prompt'.

	^ server
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> serverWithResource [
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
GtMcpServerExamples >> serverWithTool [
	<gtExample>
	| server |
	server := self simpleServer.
	server addTool: self simpleServerTool.
	self assert: server tools size equals: 1.
	^ server
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> serverWithToolWithBadRequestAndResponse [
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
GtMcpServerExamples >> serverWithToolWithSuccessfulRequestAndResponse [
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
		assert: jsonResultContent first
		equals: {'text' -> 'hello from tool'.
				'type' -> 'text'} asDictionary.

	^ server
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> simpleServer [
	<gtExample>
	| server simpleRequest |
	server := GtMcpServer new.

	self assert: server port equals: 0.
	self assert: server isDebug not.

	simpleRequest := self simpleServerRequest.
	self
		assert: (server handleRequest: simpleRequest)
		equals: (ZnResponse badRequest: simpleRequest).

	^ server
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> simpleServerPrompt [
	<gtExample>
	^ GtMcpPrompt new
		name: 'Prompt';
		arguments: {'argument'};
		description: 'A prompt';
		promptBlock: [ :arguments | {GtLlmUserMessage new content: (arguments at: 'argument')} ]
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> simpleServerRequest [
	<gtExample>
	^ self serverRequestWithEntity: {} asDictionary
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> simpleServerResource [
	<gtExample>
	^ GtMcpResource new
		name: 'Resource';
		description: 'A Resource';
		mimeType: ZnMimeType textPlain;
		uri: 'resource';
		contentsBlock: [ 'hello from resource' ]
]

{ #category : #'as yet unclassified' }
GtMcpServerExamples >> simpleServerTool [
	<gtExample>
	^ GtLlmFunctionTool new
		name: 'Tool';
		parameters: {'param'};
		description: 'A Tool';
		block: [  :functionCall | "echos the argument back" functionCall anyArgument ]
]
