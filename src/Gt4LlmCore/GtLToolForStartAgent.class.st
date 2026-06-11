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
    "model": "gpt-4.1",
    "inheritCurrentHistory": true
  }
}

Example JSON response:
{
  "agentName": "Explore",
  "description": "Agent for investigating the current system",
  "prompt": "Explore the code relevant to the current request.",
  "model": "gpt-4.1",
  "inheritCurrentHistory": true
}'
]

{ #category : #private }
GtLToolForStartAgent >> findAgentNamed: aString inChat: aChat [
	^aChat agents
		detect: [ :each | each hasName: aString ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtLToolForStartAgent >> name [
	^ 'startAgent'
]

{ #category : #private }
GtLToolForStartAgent >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request currentChat agent agentExecution executionError |
	
	request := aToolCall arguments at: 'startAgentRequest'.
	
	currentChat := anExecutionContext currentChat.
	currentChat ifNil: [ ^ GtLMissingDomainObject new objectName: 'chat' ].
	
	self validateRequest: request onError: [ :anError | ^ anError ].
	
	agent := self findAgentNamed: request agentName inChat: currentChat.
	agent ifNil: [ ^ GtLMissingDomainObject new objectName: request agentName ].
	
	agentExecution := agent startFromChat: currentChat fromRequest: request inContext: anExecutionContext.
	aToolCall at: #innerChat putRuntimeValue: agentExecution agentChat.
	
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
