Class {
	#name : #GtLExploreAgentExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Agents'
}

{ #category : #examples }
GtLExploreAgentExamples >> agentPrintStringWithModelName [
	<gtExample>
	| anAgent |
	anAgent := GtLSystemExplorationAgent new.
	anAgent modelName: 'gpt-4'.
	self assert: anAgent printString equals: 'Agent: explore; An agent specialized in exploring the current system and context.'.
	^ anAgent
]

{ #category : #examples }
GtLExploreAgentExamples >> agentPrintStringWithoutModelName [
	<gtExample>
	| anAgent |
	anAgent := GtLSystemExplorationAgent new.
	self assert: anAgent printString equals: 'Agent: explore; An agent specialized in exploring the current system and context.'.
	^ anAgent
]
