"
Abstract model of an LLM agent.
"
Class {
	#name : #GtLAgent,
	#superclass : #Object,
	#instVars : [
		'modelName'
	],
	#category : #'Gt4LlmCore-Agents'
}

{ #category : #testing }
GtLAgent class >> isAbstract [
	^ self name = #GtLAgent
]

{ #category : #accessing }
GtLAgent >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLInstructionSection new
				title: self name;
				body: (self createInstructionString))
]

{ #category : #accessing }
GtLAgent >> agentName [
	^ self name
]

{ #category : #running }
GtLAgent >> configureAgentChat: anAgentChat [ 
	"Do not allow agents in an agent"
	anAgentChat agents: GtLAgents new.
	
	anAgentChat pageObjectExplanation: self lepiterExplanationPage
]

{ #category : #running }
GtLAgent >> createAgentChatForParentChat: aChat fromRequest: aStartAgentRequest [ 
	| agentChat |
	
	agentChat := aStartAgentRequest shouldForkCurrentChat
		ifTrue: [ aChat copyForIndependentRequest ]
		ifFalse: [ self createNewStandaloneChatFrom: aChat ].
	
	self configureAgentChat: agentChat.
		
	^ agentChat
]

{ #category : #running }
GtLAgent >> createExecutionForAgentChat: anAgentChat fromRequest: aStartAgentRequest inContext: anExecutionContext [
	| agentExecution agentExecutionId |
		
	agentExecution := GtLAgentExecution new 
		initialRequest: aStartAgentRequest;
		agent: self;
		agentChat: anAgentChat.
	agentExecution registerTerminationSignal.
	
	agentExecutionId := anExecutionContext objectStorage
		ifNotNil: [ :aStorage | aStorage addNewObject: agentExecution ]
		ifNil: [ nil ].
	agentExecution executionId: agentExecutionId.
	
	^ agentExecution
]

{ #category : #running }
GtLAgent >> createInstructionString [
	^ String streamContents: [ :aStream |
		aStream 
			nextPutAll: 'Agent name: ';
			nextPutAll: self name;
			cr;
			nextPutAll: 'Agent description: ';
			nextPutAll: self description]
]

{ #category : #running }
GtLAgent >> createNewStandaloneChatFrom: aCurrentChat [ 
	| agentChat |
	agentChat := GtLChat new.
	agentChat withDefaultSummarizers.
	agentChat
		tools: GtLTools gt;
		markdownResponse.
		
	aCurrentChat provider ifNotNil: [ :aProvider | 
		| newProvider |
		newProvider := aProvider copyForIndependentRequest.
		agentChat provider: newProvider ].
		
	^ agentChat
]

{ #category : #accessing }
GtLAgent >> defaultLepiterDatabase [
	^ LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLAgent >> description [
	^ self subclassResponsibility
]

{ #category : #running }
GtLAgent >> extractResponseFromMessage: anAssistantMessage [
	^ anAssistantMessage responseModels at: 'Markdown' ifAbsent: [ nil ]
]

{ #category : #testing }
GtLAgent >> hasExplanationPage [
	^ self lepiterDatabase hasPageNamed: self lepiterExplanationPageName
]

{ #category : #testing }
GtLAgent >> hasName: aString [
	^ self agentName = aString
]

{ #category : #accessing }
GtLAgent >> lepiterDatabase [
	^ self defaultLepiterDatabase
]

{ #category : #accessing }
GtLAgent >> lepiterExplanationPage [
	^ self lepiterDatabase 
			pageNamed: self lepiterExplanationPageName 
			ifAbsent: [ (LePage named: self name)
				addSnippet: (LeTextSnippet new
					string: self description;
				yourself) ]
]

{ #category : #accessing }
GtLAgent >> lepiterExplanationPageName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAgent >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLAgent >> modelName: aString [
	modelName := aString
]

{ #category : #accessing }
GtLAgent >> name [
	^ self subclassResponsibility
]

{ #category : #printing }
GtLAgent >> printOn: aStream [
	aStream
		nextPutAll: 'Agent: ';
		nextPutAll: self name;
		nextPutAll: '; ';
		nextPutAll: self description
]

{ #category : #running }
GtLAgent >> startFromChat: aChat fromRequest: aStartAgentRequest inContext: anExecutionContext [
	| agentChat agentExecution |
	
	agentChat := self createAgentChatForParentChat: aChat fromRequest: aStartAgentRequest .
		
	agentExecution := self 
		createExecutionForAgentChat: agentChat 
		fromRequest: aStartAgentRequest 
		inContext: anExecutionContext.
	agentExecution parentChat: aChat.
	
	agentChat sendMarkdown: aStartAgentRequest prompt.
	
	^ agentExecution
]
