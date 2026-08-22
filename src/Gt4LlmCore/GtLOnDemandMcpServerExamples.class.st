"
Examples for the lifecycle and unique-instance behavior of GtLOnDemandMcpServer.
"
Class {
	#name : #GtLOnDemandMcpServerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #examples }
GtLOnDemandMcpServerExamples >> runningServer [
	<gtExample>
	| onDemandServer |
	onDemandServer := GtLOnDemandMcpServer new.
	[ self assert: onDemandServer isRunning.
	self assert: onDemandServer port > 0.
	self assert: onDemandServer server tools isEmpty not ]
		ensure: [ onDemandServer stop ].
	self assert: onDemandServer isRunning not.
	^ onDemandServer
]

{ #category : #examples }
GtLOnDemandMcpServerExamples >> uniqueInstance [
	<gtExample>
	| firstInstance secondInstance |
	GtLOnDemandMcpServer cleanUniqueInstance.
	[ firstInstance := GtLOnDemandMcpServer instance.
	secondInstance := GtLOnDemandMcpServer instance.
	self assert: firstInstance == secondInstance.
	self assert: firstInstance isRunning ]
		ensure: [ GtLOnDemandMcpServer cleanUniqueInstance ].
	self assert: firstInstance isRunning not.
	^ firstInstance
]
