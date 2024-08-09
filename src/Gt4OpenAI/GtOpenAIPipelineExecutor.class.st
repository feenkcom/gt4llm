Class {
	#name : #GtOpenAIPipelineExecutor,
	#superclass : #Object,
	#instVars : [
		'pipeline',
		'threadMessage'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #executing }
GtOpenAIPipelineExecutor >> await [
	^ self future await: GtOpenAIUtilities executionConfiguration
]

{ #category : #accessing }
GtOpenAIPipelineExecutor >> check: aString [
	| result |
	result := (pipeline check: aString) threadMessage: self threadMessage.
	self threadMessage announce: (GtLlmExecutionAnnouncement new result: result).
	^ result
]

{ #category : #executing }
GtOpenAIPipelineExecutor >> future [
	^ [ self check ] asAsyncFuture
]

{ #category : #accessing }
GtOpenAIPipelineExecutor >> pipeline: aPipeline [
	pipeline := aPipeline
]

{ #category : #accessing }
GtOpenAIPipelineExecutor >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
GtOpenAIPipelineExecutor >> threadMessage: anObject [
	threadMessage := anObject
]
