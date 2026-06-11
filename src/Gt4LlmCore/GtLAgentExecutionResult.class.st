"
Result of starting an agent from a chat.
"
Class {
	#name : #GtLAgentExecutionResult,
	#superclass : #Object,
	#instVars : [
		'request',
		'content',
		'totalDurationMs',
		'totalTokens',
		'totalToolUseCount',
		'agentExecutionId',
		'parentChat',
		'agentExecution'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLAgentExecutionResult >> agentExecution [
	^ agentExecution
]

{ #category : #accessing }
GtLAgentExecutionResult >> agentExecution: anObject [
	agentExecution := anObject
]

{ #category : #accessing }
GtLAgentExecutionResult >> agentExecutionId [
	^ agentExecutionId
]

{ #category : #accessing }
GtLAgentExecutionResult >> agentExecutionId: aString [
	agentExecutionId := aString
]

{ #category : #magritte }
GtLAgentExecutionResult >> agentExecutionIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Agent id';
		accessor: #agentExecutionId;
		comment: 'The id of the execution running the agent';
		beRequired
]

{ #category : #accessing }
GtLAgentExecutionResult >> content [
	^ content
]

{ #category : #accessing }
GtLAgentExecutionResult >> content: aString [
	content := aString
]

{ #category : #magritte }
GtLAgentExecutionResult >> contentDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
			accessor: #content;
			classes: { GtLMarkdown};
			comment: 'The response returned by the agent';
			beRequired
]

{ #category : #views }
GtLAgentExecutionResult >> gtAgentExecutionFor: aView [
	<gtView>
	<gtLlmView>
		
	^ aView forward
		title: 'Agent chat';
		priority: 10.5;
		object: [ agentExecution ];
		view: #gtAgentChatFor:
]

{ #category : #views }
GtLAgentExecutionResult >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Agent response';
		priority: 10;
		object: [ content ];
		view: #gtMarkdownFor:
]

{ #category : #accessing }
GtLAgentExecutionResult >> parentChat [
	^ parentChat
]

{ #category : #accessing }
GtLAgentExecutionResult >> parentChat: anObject [
	parentChat := anObject
]

{ #category : #accessing }
GtLAgentExecutionResult >> request [
	^ request
]

{ #category : #accessing }
GtLAgentExecutionResult >> request: anObject [
	request := anObject
]

{ #category : #accessing }
GtLAgentExecutionResult >> totalDurationMs [
	^ totalDurationMs
]

{ #category : #accessing }
GtLAgentExecutionResult >> totalDurationMs: aNumber [
	totalDurationMs := aNumber
]

{ #category : #magritte }
GtLAgentExecutionResult >> totalDurationMsDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Total duration ms';
		accessor: #totalDurationMs;
		comment: 'The total duration of the agent in milliseconds';
		beOptional
]

{ #category : #accessing }
GtLAgentExecutionResult >> totalTokens [
	^ totalTokens
]

{ #category : #accessing }
GtLAgentExecutionResult >> totalTokens: aNumber [
	totalTokens := aNumber
]

{ #category : #magritte }
GtLAgentExecutionResult >> totalTokensDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Total tokens';
		accessor: #totalTokens;
		comment: 'The total number of tokens used by the agent';
		beOptional
]

{ #category : #accessing }
GtLAgentExecutionResult >> totalToolUseCount [
	^ totalToolUseCount
]

{ #category : #accessing }
GtLAgentExecutionResult >> totalToolUseCount: aNumber [
	totalToolUseCount := aNumber
]

{ #category : #magritte }
GtLAgentExecutionResult >> totalToolUseCountDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Total tool use count';
		accessor: #totalToolUseCount;
		comment: 'The total number of tools used by the agent';
		beOptional
]
