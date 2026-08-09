"
Examples for GtLConnectionRegistry, especially for the pragma-driven collection of known connectors.
"
Class {
	#name : #GtLConnectionRegistryExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Registry'
}

{ #category : #examples }
GtLConnectionRegistryExamples >> anthropicConnectorsComeFromPragma [
	<gtExample>
	<return: #Collection>
	| anthropic registry connectors |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	anthropic := registry connections value
		select: [ :each | each providerClass == GtLAnthropicProvider ].
	connectors := GtLAnthropicProvider knownConnectors.
	self assert: anthropic size equals: connectors size.
	self
		assert: (anthropic collect: #model) asSet
		equals: (connectors collect: #model) asSet.
	^ anthropic
]

{ #category : #examples }
GtLConnectionRegistryExamples >> collectsKnownConnectorsViaPragma [
	<gtExample>
	<return: #Collection>
	"The registry collects `knownConnectors` by walking all classes that
	advertise a `<gtConnection>` pragma and asking each one for its list."
	| registry pragmaClasses providerClasses |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	pragmaClasses := (Pragma allNamed: #gtConnection)
		collect: [ :pragma | pragma methodClass instanceSide ] as: Set.
	providerClasses := registry connections value
		collect: [ :aConnection | aConnection providerClass ]
		as: Set.
	self assert: providerClasses notEmpty.
	self assert: (pragmaClasses includesAll: providerClasses).
	^ registry connections value
]

{ #category : #examples }
GtLConnectionRegistryExamples >> connectionRegistry [
	<gtExample>
	<return: #GtLConnectionRegistry>
	self assert: GtLConnectionRegistry default identicalTo: GtLConnectionRegistry uniqueInstance.
	^ GtLConnectionRegistry default
]

{ #category : #examples }
GtLConnectionRegistryExamples >> minimaxConnectorsComeFromPragma [
	<gtExample>
	<return: #Collection>
	| registry minis |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	minis := registry connections value
		select: [ :each | each providerClass == GtLMiniMaxOpenAIProvider ].
	self assert: minis size equals: GtLMiniMaxOpenAIProvider knownConnectors size.
	self
		assert: (minis collect: #model) asSet
		equals: (GtLMiniMaxOpenAIProvider knownConnectors collect: #model) asSet.
	^ minis
]

{ #category : #examples }
GtLConnectionRegistryExamples >> ollamaConnectorsComeFromPragma [
	<gtExample>
	<return: #Collection>
	| registry ollama |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	ollama := registry connections value
		select: [ :each | each providerClass == GtLOllamaProvider ].
	self
		assert: ollama
		equals: GtLOllamaProvider knownConnectors.
	^ ollama
]

{ #category : #examples }
GtLConnectionRegistryExamples >> openAIConnectorsComeFromPragma [
	<gtExample>
	<return: #Collection>
	| registry openAI |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	openAI := registry connections value
		select: [ :each | each providerClass == GtLOpenAIProvider ].
	self assert: openAI size equals: GtLOpenAIProvider knownConnectors size.
	self
		assert: (openAI collect: #model) asSet
		equals: (GtLOpenAIProvider knownConnectors collect: #model) asSet.
	^ openAI
]

{ #category : #examples }
GtLConnectionRegistryExamples >> standardDefaultConnectionIsStillWiredUp [
	<gtExample>
	<return: #GtLConnection>
	"The registry wires up `standardDefaultConnection` after collecting the
	pragma-driven list, so the default survives the refactor."
	| registry |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	self assert: registry defaultConnection model equals: 'gpt-5.4'.
	^ registry defaultConnection
]
