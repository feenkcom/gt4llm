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
	self assert: GtLConnectionRegistry default == GtLConnectionRegistry uniqueInstance.
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
		assert: ollama size
		equals: GtLOllamaProvider knownConnectors size.
	self
		assert: (ollama collect: #model) asSet
		equals: (GtLOllamaProvider knownConnectors collect: #model) asSet.
	^ ollama
]

{ #category : #examples }
GtLConnectionRegistryExamples >> openAIConnectorsComeFromPragma [
	<gtExample>
	<return: #Collection>
	"OpenAI's static `<gtConnection>` list contributes 5 entries; the registry
	then adds the standard default connection (GPT 5.4) on top, totalling 6."
	| registry openAI pragmaListed |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	pragmaListed := registry connections value
		select: [ :each | each providerClass == GtLOpenAIProvider and: [ each model ~= 'gpt-5.4' ] ].
	self assert: pragmaListed size equals: GtLOpenAIProvider knownConnectors size.
	self
		assert: (pragmaListed collect: #model) asSet
		equals: (GtLOpenAIProvider knownConnectors collect: #model) asSet.
	openAI := registry connections value
		select: [ :each | each providerClass == GtLOpenAIProvider ].
	self assert: openAI size equals: GtLOpenAIProvider knownConnectors size + 1.
	^ openAI
]

{ #category : #examples }
GtLConnectionRegistryExamples >> standardDefaultConnectionIsStillWiredUp [
	<gtExample>
	<return: #GtLConnection>
	"The registry wires up `standardDefaultConnection` after collecting the
	pragma-driven list. The default survives the refactor. The chosen
	connection depends on which providers are connectable in this image:
	- If OpenAI is connectable, the registry honours `standardDefaultConnection`
	  (GPT 5.4). 
	- Otherwise, it falls back to the first connectable connector returned by
	  the pragma-driven list (in this image, MiniMax-M3)."
	| registry dc |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	dc := registry defaultConnection.
	self assert: dc notNil.
	self
		assert: dc model
		equals: (dc model = 'gpt-5.4'
			ifTrue: [ 'gpt-5.4' ]
			ifFalse: [ 'MiniMax-M3' ]).
	^ dc
]
