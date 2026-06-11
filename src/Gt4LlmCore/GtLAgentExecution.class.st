Class {
	#name : #GtLAgentExecution,
	#superclass : #Object,
	#instVars : [
		'agent',
		'agentChat',
		'initialRequest',
		'terminationSemaphore',
		'executionId',
		'parentChat'
	],
	#category : #'Gt4LlmCore-Agents'
}

{ #category : #accessing }
GtLAgentExecution >> agent [
	^ agent
]

{ #category : #accessing }
GtLAgentExecution >> agent: anObject [
	agent := anObject
]

{ #category : #accessing }
GtLAgentExecution >> agentChat [
	^ agentChat
]

{ #category : #accessing }
GtLAgentExecution >> agentChat: anObject [
	agentChat := anObject
]

{ #category : #execution }
GtLAgentExecution >> createAgentResponse [
	| responseMessage  responseContent|
	
	responseMessage := self responseMessage.
	responseMessage ifNil: [ 
		^ GtLProblemDomainObject new
				description: 'No response message detected in agent chat.' ].
				
	responseContent := self agent extractResponseFromMessage: responseMessage.
	responseMessage ifNil: [ 
		^ GtLProblemDomainObject new
				description: 'Missing response in response message' ].

	^ GtLAgentExecutionResult new
		agentExecutionId: self executionId;
		agentExecution: self;
		parentChat: self parentChat;
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
GtLAgentExecution >> gtAgentChatFor: aView [
	<gtView>
	^ aView forward
		title: 'Agent chat';
		priority: 20;
		object: [ agentChat ];
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
GtLAgentExecution >> parentChat [
	^ parentChat
]

{ #category : #accessing }
GtLAgentExecution >> parentChat: anObject [
	parentChat := anObject
]

{ #category : #execution }
GtLAgentExecution >> registerTerminationSignal [
	terminationSemaphore := Semaphore new.
	agentChat announcer
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #signal
		to: terminationSemaphore.
]

{ #category : #execution }
GtLAgentExecution >> responseMessage [
	^ self agentChat messages
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
	
	agentChat announcer unsubscribe: terminationSemaphore.
	timeout ifTrue: [ 
		^ GtLProblemDomainObject new
				description: 'Agent did not finish in time' ].
				
	^ nil
]
