Class {
	#name : #GtLOpenAiCodexExamples,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Codex'
}

{ #category : #examples }
GtLOpenAiCodexExamples >> byteArrayResponseIsUtf8Decoded [
	<gtExample>
	| client |
	client := GtLOpenAiCodexClient new.
	self
		assert: (client responseStringFrom: 'response.completed' utf8Encoded)
		equals: 'response.completed'.
	^ client
]

{ #category : #examples }
GtLOpenAiCodexExamples >> completeJsonResponseIsAccepted [
	<gtExample>
	| accumulator response |
	accumulator := GtLOpenAiCodexSseAccumulator new.
	accumulator consume: '{"id":"resp_789","status":"completed","output":[]}'.
	response := accumulator result.
	self assert: (response at: 'id') equals: 'resp_789'.
	^ accumulator
]

{ #category : #examples }
GtLOpenAiCodexExamples >> functionCallIsReconstructedFromSseEvents [
	<gtExample>
	| accumulator response functionCall |
	accumulator := GtLOpenAiCodexSseAccumulator new.
	accumulator consume:
		'data: {"type":"response.output_item.done","item":{"type":"function_call","call_id":"call_123","name":"lookupClass","arguments":"{\"className\":\"Object\"}"}}',
		String lf, String lf,
		'data: {"type":"response.completed","response":{"id":"resp_tools","status":"completed","output":[]}}',
		String lf, String lf.
	response := accumulator result.
	functionCall := (response at: 'output') first.
	self assert: (functionCall at: 'type') equals: 'function_call'.
	self assert: (functionCall at: 'call_id') equals: 'call_123'.
	^ accumulator
]

{ #category : #examples }
GtLOpenAiCodexExamples >> outputTextIsReconstructedFromSseEvents [
	<gtExample>
	| accumulator response output content |
	accumulator := GtLOpenAiCodexSseAccumulator new.
	accumulator consume:
		'data: {"type":"response.output_text.done","text":"GT_CODEX_OK"}',
		String lf, String lf,
		'data: {"type":"response.completed","response":{"id":"resp_999","status":"completed","output":[]}}',
		String lf, String lf.
	response := accumulator result.
	output := response at: 'output'.
	content := (output first at: 'content') first.
	self assert: (content at: 'text') equals: 'GT_CODEX_OK'.
	^ accumulator
]

{ #category : #examples }
GtLOpenAiCodexExamples >> providerWiresTheCodexTransport [
	<gtExample>
	| credential provider endpoint |
	credential := GtLOpenAiCodexCredential
		accessToken: 'test-access-token'
		refreshToken: 'test-refresh-token'
		expiresAt: DateAndTime now + 1 hour
		accountId: 'account_123'.
	provider := GtLOpenAiCodexProvider new credential: credential.
	endpoint := provider model endpointAt: 'userMessage'.
	self assert: provider model client class equals: GtLOpenAiCodexClient.
	self assert: endpoint class equals: GtLOpenAiCodexResponsesEndpoint.
	self assert: endpoint path equals: '/backend-api/codex/responses'.
	self assert: provider credential equals: credential.
	^ provider
]

{ #category : #examples }
GtLOpenAiCodexExamples >> requestBodyUsesCodexStreamingOptions [
	<gtExample>
	| endpoint entity |
	endpoint := GtLOpenAiCodexResponsesEndpoint new.
	entity := Dictionary new.
	endpoint addAdditionalEntityTo: entity.
	self assert: (entity at: 'stream').
	self assert: (entity at: 'store') equals: false.
	self assert: (entity at: 'parallel_tool_calls').
	self assert: (entity at: 'include') equals: #('reasoning.encrypted_content').
	^ endpoint
]

{ #category : #examples }
GtLOpenAiCodexExamples >> sseTerminalResponse [
	<gtExample>
	| accumulator response |
	accumulator := GtLOpenAiCodexSseAccumulator new.
	accumulator consume: 'event: response.completed', String lf,
		'data: {"type":"response.completed","response":{"id":"resp_123","status":"completed","output":[]}}',
		String lf, String lf.
	response := accumulator result.
	self assert: (response at: 'id') equals: 'resp_123'.
	self assert: (response at: 'status') equals: 'completed'.
	^ accumulator
]

{ #category : #examples }
GtLOpenAiCodexExamples >> sseTerminalResponseAcrossChunks [
	<gtExample>
	| accumulator response firstChunk secondChunk |
	accumulator := GtLOpenAiCodexSseAccumulator new.
	firstChunk := 'event: response.completed', String lf,
		'data: {"type":"response.completed","response":{"id":"resp_'.
	secondChunk := '456","status":"completed","output":[]}}', String lf, String lf.
	accumulator consume: firstChunk.
	accumulator consume: secondChunk.
	response := accumulator result.
	self assert: (response at: 'id') equals: 'resp_456'.
	^ accumulator
]

{ #category : #examples }
GtLOpenAiCodexExamples >> streamingRequestHasCodexHeaders [
	<gtExample>
	| credential client headers |
	credential := GtLOpenAiCodexCredential
		accessToken: 'test-access-token'
		refreshToken: 'test-refresh-token'
		expiresAt: DateAndTime now + 1 hour
		accountId: 'account_123'.
	client := GtLOpenAiCodexClient new.
	client credential: credential.
	headers := client newStreamingHttpClient request headers.
	self assert: (headers at: 'Accept') equals: 'text/event-stream'.
	self assert: (headers at: 'Chatgpt-Account-Id') equals: 'account_123'.
	self assert: (headers at: 'Openai-Beta') equals: 'responses=experimental'.
	^ client
]
