Class {
	#name : #GtLMcpClientExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> clientListPrompts [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'prompts' -> {}} asDictionary} asDictionary.

	self assert: client listPrompts size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> clientListResources [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'resources' -> {}} asDictionary} asDictionary.

	self assert: client listResources size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> clientListTools [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'tools' -> {}} asDictionary} asDictionary.

	self assert: client listTools size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> simpleClient [
	<gtExample>
	^ GtLMcpClient new
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> simpleClientWithTransport [
	<gtExample>
	^ GtLMcpClient new
		transport: (GtLMcpStaticTransport new
				messages: {{'result'
								-> {'capabilities'
											-> {'tools' -> {} asDictionary.
													'prompts' -> {} asDictionary.
													'resources' -> {} asDictionary} asDictionary} asDictionary}
							asDictionary}asOrderedCollection)
]

{ #category : #'mcp tools' }
GtLMcpClientExamples >> callToolKeepsContentCompatibility [
	<gtExample>
	| client content |
	client := self simpleClientWithTransport.
	client transport addMessage:
		{'result' -> {
			'content' -> {{'type' -> 'text'. 'text' -> 'ok'} asDictionary}.
			'structuredContent' -> {'answer' -> 42} asDictionary
		} asDictionary} asDictionary.

	content := client
		callTool: 'example'
		withArguments: {'value' -> 1} asDictionary.

	self assert: content equals:
		{{'type' -> 'text'. 'text' -> 'ok'} asDictionary}.

	^ content
]

{ #category : #'mcp tools' }
GtLMcpClientExamples >> callToolResultPreservesStructuredContent [
	<gtExample>
	| client expected result |
	client := self simpleClientWithTransport.
	expected := {
		'content' -> {{'type' -> 'text'. 'text' -> 'ok'} asDictionary}.
		'structuredContent' -> {
			'answer' -> 42.
			'nested' -> {'value' -> true} asDictionary
		} asDictionary.
		'isError' -> false
	} asDictionary.
	client transport
		addMessage: {'result' -> expected} asDictionary.

	result := client
		callToolResult: 'example'
		withArguments: {'value' -> 1} asDictionary.

	self assert: result equals: expected.

	^ result
]

{ #category : #'mcp tools' }
GtLMcpClientExamples >> llmFunctionToolPreservesInputSchemaAndCompleteResult [
	<gtExample>
	| client schema definition tools tool expected call result |
	client := self simpleClientWithTransport.
	schema := {
		'type' -> 'object'.
		'properties' -> {
			'request' -> {
				'type' -> 'object'.
				'properties' -> {
					'service_id' -> {'type' -> 'string'} asDictionary
				} asDictionary.
				'required' -> #('service_id')
			} asDictionary
		} asDictionary.
		'required' -> #('request')
	} asDictionary.
	definition := {
		'name' -> 'get_service_dependencies'.
		'description' -> 'Return dependencies for a service.'.
		'inputSchema' -> schema
	} asDictionary.

	client transport addMessage:
		{'result' -> {'tools' -> {definition}} asDictionary} asDictionary.

	tools := client llmFunctionTools.
	self assert: tools size equals: 1.
	tool := tools first.

	self assert: tool class equals: GtLMcpFunctionTool.
	self assert: tool parametersJsonSchemaDictionary equals: schema.
	self assert: (tool functionOpenAI at: 'parameters') equals: schema.

	expected := {
		'content' -> {{'type' -> 'text'. 'text' -> 'fallback'} asDictionary}.
		'structuredContent' -> {
			'outcome' -> 'ANSWERED'.
			'claims' -> #()
		} asDictionary.
		'isError' -> false
	} asDictionary.
	client transport addMessage:
		{'result' -> expected} asDictionary.

	call := GtLFunctionToolCall new
		name: tool name;
		arguments: {
			'request' -> {'service_id' -> 'service:order-service'} asDictionary
		} asDictionary;
		yourself.

	result := tool performToolCall: call.

	self assert: result model class equals: GtLPlainJson.
	self assert: result model jsonValue equals: expected.

	^ result
]
