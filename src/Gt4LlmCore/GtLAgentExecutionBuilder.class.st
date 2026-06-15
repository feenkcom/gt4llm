"
Abstract model of an LLM agent.
"
Class {
	#name : #GtLAgentExecutionBuilder,
	#superclass : #Object,
	#instVars : [
		'agentCreationReauest'
	],
	#category : #'Gt4LlmCore-Agents'
}

{ #category : #'instance creation' }
GtLAgentExecutionBuilder class >> forAgentCreationRequest: aRequest [ 
	^self new 
		agentCreationReauest: aRequest
]

{ #category : #accessing }
GtLAgentExecutionBuilder >> agentCreationReauest [
	^ agentCreationReauest
]

{ #category : #accessing }
GtLAgentExecutionBuilder >> agentCreationReauest: anObject [
	agentCreationReauest := anObject
]

{ #category : #running }
GtLAgentExecutionBuilder >> configureAgentChat: anAgentChat [ 
	"Do not allow agents in an agent"
	"TODO"
	
	agentCreationReauest instructionPageReferences do: [ :aPageReference |
		| targetPage |
		targetPage := self locatePageForReference: aPageReference.
		targetPage ifNotNil: [ :aPage |
			anAgentChat pageObjectExplanation: aPage ] ] 
]

{ #category : #running }
GtLAgentExecutionBuilder >> createAgentForParent: anAgent [
	| newAgent |
	
	newAgent := agentCreationReauest shouldForkCurrentAgent
		ifTrue: [ anAgent copyForIndependentRequest ]
		ifFalse: [ self createNewStandaloneChatFrom: anAgent ].
	
	self configureAgentChat: newAgent.
		
	^ newAgent
]

{ #category : #running }
GtLAgentExecutionBuilder >> createExecutionForAgent: anAgent inContext: anExecutionContext [
	| agentExecution agentExecutionId |
		
	agentExecution := GtLAgentExecution new 
		initialRequest: agentCreationReauest;
		agent: anAgent.
	agentExecution registerTerminationSignal.
	
	agentExecutionId := anExecutionContext objectStorage
		ifNotNil: [ :aStorage | aStorage addNewObject: agentExecution ]
		ifNil: [ nil ].
	agentExecution executionId: agentExecutionId.
	
	^ agentExecution
]

{ #category : #running }
GtLAgentExecutionBuilder >> createNewStandaloneChatFrom: aParentAgent [ 
	| newAgent |
	newAgent := GtLChat new.
	newAgent withDefaultSummarizers.
	newAgent
		tools: GtLTools gt;
		markdownResponse.
		
	aParentAgent provider ifNotNil: [ :aProvider | 
		| newProvider |
		newProvider := aProvider copyForIndependentRequest.
		newAgent provider: newProvider ].
		
	^ newAgent
]

{ #category : #accessing }
GtLAgentExecutionBuilder >> defaultLepiterDatabase [
	^ LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLAgentExecutionBuilder >> lepiterDatabase [
	^ self defaultLepiterDatabase
]

{ #category : #running }
GtLAgentExecutionBuilder >> locateDatabaseForReference: aPageReference [ 
	| targetDatabase |
	targetDatabase := self lepiterDatabase isLogicalDatabase 
		ifTrue: [
			 self lepiterDatabase
				databaseWithID: aPageReference databaseId
		  	ifNone: [ nil ] ]
		 ifFalse: [
		 		self lepiterDatabase uuid asString  = aPageReference databaseId 
		 			ifTrue: [self lepiterDatabase]
		 			ifFalse: [nil]].
	^ targetDatabase 
]

{ #category : #running }
GtLAgentExecutionBuilder >> locatePageForReference: aPageReference [ 
	| targetDatabase |
	targetDatabase := self locateDatabaseForReference: aPageReference.
	^ targetDatabase 
		ifNotNil: [ :aDatabase |
			aDatabase pageWithID: aPageReference pageId ifAbsent: [ nil ] ]
]

{ #category : #printing }
GtLAgentExecutionBuilder >> printOn: aStream [
	aStream
		nextPutAll: 'Agent: ';
		nextPutAll: agentCreationReauest agentName;
		nextPutAll: '; ';
		nextPutAll: agentCreationReauest taskDescription
]

{ #category : #running }
GtLAgentExecutionBuilder >> startFromParentAgent: aParentAgent inContext: anExecutionContext [
	| agent agentExecution |
	
	agent := self createAgentForParent: aParentAgent.
		
	agentExecution := self 
		createExecutionForAgent: agent 
		inContext: anExecutionContext.
	agentExecution parentAgent: aParentAgent.
	
	agent sendMarkdown: agentCreationReauest prompt.
	
	^ agentExecution
]

{ #category : #running }
GtLAgentExecutionBuilder >> validateExecutionIfErrorDo: anErrorBlock [
	agentCreationReauest instructionPageReferences do: [ :aPageReference | 
		| targetDatabase |
		targetDatabase := self locateDatabaseForReference: aPageReference.
		targetDatabase ifNil: [
			^ GtLProblemDomainObject new
				description: ('Database with id {1} not found' format: {
					aPageReference databaseId asString })].
				
		(targetDatabase 
			pageWithID: aPageReference pageId
			ifAbsent: [ 
				^ GtLProblemDomainObject new
					description: ('Page with with id {1} not found in database with id {2}' format: {
						aPageReference pageId asString,
						aPageReference databaseId asString}) ]) ]
	
]
