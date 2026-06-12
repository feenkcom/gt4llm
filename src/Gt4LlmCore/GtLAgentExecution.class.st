Class {
	#name : #GtLAgentExecution,
	#superclass : #Object,
	#instVars : [
		'agent',
		'initialRequest',
		'terminationSemaphore',
		'executionId',
		'parentAgent'
	],
	#category : #'Gt4LlmCore-Agents'
}

{ #category : #accessing }
GtLAgentExecution >> agent [
	^ agent
]

{ #category : #accessing }
GtLAgentExecution >> agent: anAgent [
	agent := anAgent
]

{ #category : #execution }
GtLAgentExecution >> createAgentResponse [
	| responseMessage  responseContent|
	
	responseMessage := self responseMessage.
	responseMessage ifNil: [ 
		^ GtLProblemDomainObject new
				description: 'No response message detected in agent chat.' ].
				
	responseContent := responseMessage responseModels at: 'Markdown' ifAbsent: [ nil ].
	responseMessage ifNil: [ 
		^ GtLProblemDomainObject new
				description: 'Missing response in response message' ].

	^ GtLAgentExecutionResult new
		agentExecutionId: self executionId;
		agentExecution: self;
		parentAgent: self parentAgent;
		request: initialRequest;
		content: responseContent;
		"totalDurationMs: 0;
		totalTokens: 0;
		totalToolUseCount: 0;"
		yourself
]

{ #category : #accessing }
GtLAgentExecution >> executionId [
	^ executionId
]

{ #category : #accessing }
GtLAgentExecution >> executionId: anObject [
	executionId := anObject
]

{ #category : #views }
GtLAgentExecution >> gtViewAgentFor: aView [
	<gtView>
	^ aView forward
		title: 'Agent';
		priority: 20;
		object: [ agent ];
		view: #gtLiveChatFor:
]

{ #category : #views }
GtLAgentExecution >> gtViewInitialRequestPromptFor: aView [
	<gtView>
	^ aView forward
		title: 'Agent prompt';
		priority: 10;
		object: [ initialRequest ];
		view: #gtViewPromptFor:
]

{ #category : #accessing }
GtLAgentExecution >> initialRequest [
	^ initialRequest
]

{ #category : #accessing }
GtLAgentExecution >> initialRequest: anObject [
	initialRequest := anObject
]

{ #category : #accessing }
GtLAgentExecution >> parentAgent [
	^ parentAgent
]

{ #category : #accessing }
GtLAgentExecution >> parentAgent: anAgent [
	parentAgent := anAgent
]

{ #category : #execution }
GtLAgentExecution >> registerTerminationSignal [
	terminationSemaphore := Semaphore new.
	agent announcer
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #signal
		to: terminationSemaphore.
]

{ #category : #accessing }
GtLAgentExecution >> responseMessage [
	^ self agent messages
		ifEmpty: [ nil ] 
		ifNotEmpty: [ :aMessagGroup |
			aMessagGroup last isReplyMessage 
				ifTrue: [ aMessagGroup last finalMessage ]
				ifFalse: [ nil ] ] 
]

{ #category : #execution }
GtLAgentExecution >> waitUntilCompletionOrTimeout [
	| timeout |
		
	timeout := terminationSemaphore waitTimeoutSeconds: 1200.
	
	agent announcer unsubscribe: terminationSemaphore.
	timeout ifTrue: [ 
		^ GtLProblemDomainObject new
				description: 'Agent did not finish in time' ].
				
	^ nil
]
