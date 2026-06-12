"
Examples for the start agent tool.
"
Class {
	#name : #GtLToolStartAgentExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Agents'
}

{ #category : #private }
GtLToolStartAgentExamples >> chatWithExploreAgent [
	| chat agent |
	chat := GtLChat new.
	chat provider: GtLOpenAIProvider new.
	agent := GtLSystemExplorationAgent new.
	agent modelName: 'gpt-4.1'.
	chat agents add: agent.
	^ chat
]

{ #category : #private }
GtLToolStartAgentExamples >> executionContextFor: aChat [
	| context storage |
	context := GtLToolExecutionContext new.
	storage := GtLObjectStorage new.
	storage addNewObject: aChat.
	context objectStorage: storage.
	^ context
]

{ #category : #examples }
GtLToolStartAgentExamples >> exploreAgentProvidesDefaults [
	<gtExample>
	| agent |
	agent := GtLSystemExplorationAgent new.
	agent modelName: 'gpt-4.1'.
	self assert: agent name equals: 'explore'.
	self assert: agent description equals: 'An agent specialized in exploring the current system and context.'.
	self assert: agent modelName equals: 'gpt-4.1'.
	^ agent
]

{ #category : #examples }
GtLToolStartAgentExamples >> startAgentFailsForMissingAgent [
	<gtExample>
	| chat context request tool result |
	chat := self chatWithExploreAgent.
	context := self executionContextFor: chat.
	request := GtLStartAgentRequest new
		agentName: 'Unknown';
		description: 'Unknown agent';
		prompt: '';
		model: 'gpt-4.1';
		shouldForkCurrentChat: false;
		yourself.
	tool := GtLToolForStartAgent new.
	result := tool
		privatePerformToolCall: (self toolCallFor: request)
		inContext: context.
	self assert: result isErrorDomainObject.
	^ result
]

{ #category : #examples }
GtLToolStartAgentExamples >> startAgentRequestStoresParameters [
	<gtExample>
	| request |
	request := GtLStartAgentRequest new
		agentName: 'Explore';
		description: 'Agent for exploring';
		prompt: 'Investigate the system';
		model: 'gpt-4.1';
		shouldForkCurrentChat: true;
		yourself.
	self assert: request agentName equals: 'Explore'.
	self assert: request description equals: 'Agent for exploring'.
	self assert: request prompt equals: 'Investigate the system'.
	self assert: request model equals: 'gpt-4.1'.
	self assert: request shouldForkCurrentChat.
	^ request
]

{ #category : #examples }
GtLToolStartAgentExamples >> startAgentReturnsResponseForExistingAgent [

	| chat context request tool result |
	chat := self chatWithExploreAgent.
	context := self executionContextFor: chat.
	request := GtLStartAgentRequest new
		agentName: 'Explore';
		description: 'Explore agent';
		prompt: '';
		model: 'gpt-4.1';
		shouldForkCurrentChat: false;
		yourself.
	tool := GtLToolForStartAgent new.
	result := tool
		privatePerformToolCall: (self toolCallFor: request)
		inContext: context.
	self assert: result class equals: GtLAgentExecutionResult.
	self assert: result request == request.
	self assert: result innerChat class equals: GtLChat.
	self assert: result agentExecutionId isString.
	self assert: result parentId isString.
	self assert: result totalDurationMs equals: 0.
	self assert: result totalTokens equals: 0.
	self assert: result totalToolUseCount equals: 0.
	^ result
]

{ #category : #examples }
GtLToolStartAgentExamples >> startAgentToolHasRequestParameter [
	<gtExample>
	| tool description |
	tool := GtLToolForStartAgent new.
	description := tool startAgentRequestDescription.
	self assert: description accessor selector equals: #startAgentRequest.
	self assert: description classes equals: { GtLStartAgentRequest }.
	^ description
]

{ #category : #private }
GtLToolStartAgentExamples >> toolCallFor: aRequest [
	^ GtLFunctionToolCall new
		name: GtLToolForStartAgent new name;
		arguments: {'startAgentRequest' -> aRequest} asDictionary;
		yourself
]
