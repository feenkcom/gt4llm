Class {
	#name : #GtLMcpServerExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Mcp'
}

{ #category : #utils }
GtLMcpServerExamples >> createBadRequestWithMessage: aMessage for: aRequest [
	|message|
	message := String streamContents: [ :out |
		out << 'Bad Request '; << aRequest method; space.
		aRequest uri printPathQueryFragmentOn: out.
		out << ('; ', aMessage) ].
	^ZnResponse 
			badRequest: aRequest
			entity: (ZnEntity textCRLF: message).
]

{ #category : #examples }
GtLMcpServerExamples >> serverRequestWithEntity: anObject [
	^ (ZnRequest post: '/')
		entity: (ZnEntity json: (STONJSON toString: anObject))
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithPrompt [
	<gtExample>
	| server request response messageData |
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

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''name'' not found in Dictionary'
				for: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'prompts/get'.
					'params' -> {'name' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'NotFound: [ :aResource | aResource name = (aJsonRpc params at: ''name'') ] not found in OrderedCollection'
				for: request).


	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'prompts/get'.
					'params'
						-> {'name' -> 'Prompt'.
								'arguments' -> {'argument' -> 'hello from prompt'} asDictionary}
								asDictionary} asDictionary.
	response := server handleRequest: request.

	messageData := (((STONJSON fromString: response entity contents) at: 'result' at: 'messages')
				first at: 'content') first.
	
	self
		assert: (messageData at: 'type')
		equals: 'text'.
		
		self
		assert: (((STONJSON fromString: (messageData at: 'text')) at: 'Markdown') at: 'content')		
		equals: 'hello from prompt'.

	^ server
]

{ #category : #examples }
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

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''uri'' not found in Dictionary'
				for: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'resources/read'.
					'params' -> {'uri' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.

	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'NotFound: [ :aResource | aResource uri = (aJsonRpc params at: ''uri'') ] not found in OrderedCollection'
				for: request).


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

{ #category : #examples }
GtLMcpServerExamples >> serverWithTool [
	<gtExample>
	| server |
	server := self simpleServer.
	server addTool: self simpleServerTool.
	self assert: server tools size equals: 1.
	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> serverWithToolWithBadRequestAndResponse [
	<gtExample>
	| server request response |
	server := self serverWithTool.

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'tools/call'.
					'params' -> {'invalid' -> 1} asDictionary} asDictionary.
	response := server handleRequest: request.
	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''name'' not found in Dictionary'
				for: request).

	request := self
			serverRequestWithEntity: {'jsonrpc' -> '2.0'.
					'method' -> 'tools/call'.
					'params' -> {'name' -> 'notFound'} asDictionary} asDictionary.
	response := server handleRequest: request.
	self 
		assert: response 
		equals: (self
				createBadRequestWithMessage: 'NotFound: Could not locate tool notFound'
				for: request).

	^ server
]

{ #category : #examples }
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

{ #category : #examples }
GtLMcpServerExamples >> simpleServer [
	<gtExample>
	| server simpleRequest |
	server := GtLMcpServer new.

	self assert: server port equals: 0.
	self assert: server isDebug not.

	simpleRequest := self simpleServerRequest.
	self
		assert: (server handleRequest: simpleRequest)
		equals: (self
				createBadRequestWithMessage: 'KeyNotFound: key ''jsonrpc'' not found in Dictionary'
				for: simpleRequest).

	^ server
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerPrompt [
	<gtExample>
	^ GtLMcpPrompt new
		name: 'Prompt';
		arguments: {'argument'};
		description: 'A prompt';
		promptBlock: [ :arguments | {GtLAnthropicUserMessage new 
			markdown: (arguments at: 'argument')} ]
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerRequest [
	<gtExample>
	^ self serverRequestWithEntity: {} asDictionary
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerResource [
	<gtExample>
	^ GtLMcpResource new
		name: 'Resource';
		description: 'A Resource';
		mimeType: ZnMimeType textPlain;
		uri: 'resource';
		contentsBlock: [ 'hello from resource' ]
]

{ #category : #examples }
GtLMcpServerExamples >> simpleServerTool [
	<gtExample>
	^ GtLFunctionTool new
		name: 'Tool';
		parameters: {'param'};
		description: 'A Tool';
		block: [  :functionCall |
			functionCall anyArgument ]
]
