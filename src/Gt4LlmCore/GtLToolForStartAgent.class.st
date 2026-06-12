Class {
	#name : #GtLToolForStartAgent,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForStartAgent >> description [
	^ 'Starts an agent with the provided configuration.

Example JSON arguments:
{
  "startAgentRequest": {
    "agentName": "Explore",
    "description": "Agent for investigating the current system",
    "prompt": "Explore the code relevant to the current request.",
    "modelName": "gpt-4.1",
    "shouldForkCurrentAgent": true
  }
}

Example JSON response:
{
  "agentName": "Explore",
  "description": "Agent for investigating the current system",
  "prompt": "Explore the code relevant to the current request.",
  "modelName": "gpt-4.1",
  "shouldForkCurrentAgent": true
}'
]

{ #category : #accessing }
GtLToolForStartAgent >> name [
	^ 'startAgent'
]

{ #category : #private }
GtLToolForStartAgent >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request currentAgent executionBuilder agentExecution executionError |
	
	request := aToolCall arguments at: 'startAgentRequest'.
	
	currentAgent := anExecutionContext currentChat.
	currentAgent ifNil: [ ^ GtLMissingDomainObject new objectName: 'chat' ].
	self validateRequest: request onError: [ :anError | ^ anError ].

	executionBuilder := GtLAgentExecutionBuilder forAgentCreationRequest:  request.
	executionBuilder validateExecutionIfErrorDo: [ :anError | ^ anError ].
	
	agentExecution := executionBuilder 
		startFromParentAgent: currentAgent inContext: anExecutionContext.
	aToolCall at: #innerChat putRuntimeValue: agentExecution agent.
	
	executionError := agentExecution waitUntilCompletionOrTimeout.
	executionError ifNotNil: [ ^ executionError ].
	
	^ agentExecution createAgentResponse. 
]

{ #category : #magritte }
GtLToolForStartAgent >> startAgentRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #startAgentRequest;
		classes: { GtLStartAgentRequest };
		beRequired
]

{ #category : #private }
GtLToolForStartAgent >> validateRequest: aRequest onError: anErrorBlock [
	
	aRequest agentName ifNil: [ 
		^ anErrorBlock value: (GtLMissingDomainObject new objectName: 'agentName') ].
	aRequest agentName trimBoth isEmpty ifTrue: [ 
		^ anErrorBlock value: (GtLMissingDomainObject new objectName: 'agentName') ].
]
