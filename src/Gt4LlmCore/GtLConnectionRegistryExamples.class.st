"
Examples for the Codex connections registered by GtLConnectionRegistry.
"
Class {
	#name : #GtLConnectionRegistryExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLConnectionRegistryExamples >> knownCodexConnectors [
	<gtExample>
	<return: #Collection>
	| connections |
	connections := GtLConnectionRegistry new knownCodexConnectors.

	GtLOpenAiCodexProvider isConnectable
		ifTrue: [
			self assert: connections notEmpty.
			self assert: (connections allSatisfy: [ :each | each providerClass = GtLOpenAiCodexProvider ]) ]
		ifFalse: [ self assert: connections isEmpty ].
	^ connections
]

{ #category : #examples }
GtLConnectionRegistryExamples >> knownOpenAiResponsesConnectors [
	<gtExample>
	<return: #Collection>
	| connections |
	connections := GtLConnectionRegistry new knownConnectors select: [ :each |
		each providerClass = GtLOpenAiResponsesProvider ].
	self assert: connections notEmpty.
	^ connections
]

{ #category : #examples }
GtLConnectionRegistryExamples >> standardDefaultConnection [
	<gtExample>
	<return: #GtLConnection>
	| connection |
	connection := GtLConnectionRegistry new standardDefaultConnection.

	self assert: connection providerClass equals: GtLOpenAiResponsesProvider.
	self assert: connection modelName equals: 'gpt-6.1-sol'.
	^ connection
]
