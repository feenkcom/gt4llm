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
	| connections expectedModels |
	connections := GtLConnectionRegistry new knownCodexConnectors.
	expectedModels := #('gpt-6.1-sol' 'gpt-6-astra' 'gpt-6-luna' 'gpt-5.6-terra' 'gpt-5.6-sol' 'gpt-5.6-luna').

	GtLOpenAiCodexProvider isConnectable
		ifTrue: [
			self assert: (connections collect: #modelName) asArray equals: expectedModels.
			self assert: (connections allSatisfy: [ :each | each providerClass = GtLOpenAiCodexProvider ]) ]
		ifFalse: [ self assert: connections isEmpty ].
	^ connections
]

{ #category : #examples }
GtLConnectionRegistryExamples >> knownOpenAiResponsesConnectors [
	<gtExample>
	<return: #Collection>
	| connections expectedModels |
	connections := GtLConnectionRegistry new knownConnectors select: [ :each |
		each providerClass = GtLOpenAiResponsesProvider ].
	expectedModels := #('gpt-6.1-sol' 'gpt-6-astra' 'gpt-6-luna' 'gpt-5.6-terra' 'gpt-5.6-sol' 'gpt-5.6-luna').

	self assert: (connections collect: #modelName) asArray equals: expectedModels.
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
