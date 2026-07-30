Class {
	#name : #GtLMiniMaxOpenAIClientExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-MiniMax-Examples'
}

{ #category : #examples }
GtLMiniMaxOpenAIClientExamples >> apiKeyFileChangeNotifiesMiniMaxProvider [
	<gtExample>
	<return: #Set>
	"Assert that setting `apiKeyFile:` on the MiniMax client announces
	a connectability change for the MiniMax provider, not the OpenAI one."
	| subscriber announced |
	subscriber := Object new.
	announced := Set new.
	SystemAnnouncer uniqueInstance
		when: GtLProviderFactoryConnectabilityChanged
		do: [ :a | announced add: a providerClass ]
		for: subscriber.
	[ GtLMiniMaxOpenAIClient apiKeyFile: GtLMiniMaxOpenAIClient defaultApiKeyFile ]
		ensure: [ SystemAnnouncer uniqueInstance unsubscribe: subscriber ].
	self assert: announced size equals: 1.
	self assert: announced anyOne equals: GtLMiniMaxOpenAIProvider.
	^ announced
]

{ #category : #examples }
GtLMiniMaxOpenAIClientExamples >> defaultApiKeyFileIsMiniMaxKey [
	<gtExample>
	<return: #Boolean>
	self assert: GtLMiniMaxOpenAIClient defaultApiKeyFile asString equals: (FileLocator home / '.secrets' / 'minimax-api-key.txt') asString.
	^ true
]

{ #category : #examples }
GtLMiniMaxOpenAIClientExamples >> defaultBaseUrlIsMiniMax [
	<gtExample>
	<return: #Boolean>
	self assert: GtLMiniMaxOpenAIClient new defaultBaseUrl asString equals: 'https://api.minimax.io/v1'.
	^ true
]

{ #category : #examples }
GtLMiniMaxOpenAIClientExamples >> knownMiniMaxConnections [
	<gtExample>
	<return: #OrderedCollection>
	"Assert that the connection registry exposes the MiniMax M3 and M2.7
	connectors, that they wire up to the MiniMax provider, and that the
	model ids are spelled the way the live API expects. Both
	`GtLConnectionRegistry` and `GtLlmConnectionRegistry` now collect via the
	`<gtConnection>` pragma, so each registry has the MiniMax entries it
	asks for."
	| registry connections m3 m2_7 |
	registry := GtLConnectionRegistry default.
	registry updateConnections.
	connections := registry connections value
		select: [ :each | each providerClass == GtLMiniMaxOpenAIProvider ].
	self assert: connections size equals: 4.
	m3 := connections detect: [ :each | each model = 'MiniMax-M3' ].
	m2_7 := connections detect: [ :each | each model = 'MiniMax-M2.7' ].
	self assert: m3 label equals: 'MiniMax-M3'.
	self assert: m2_7 label equals: 'MiniMax-M2.7'.
	^ connections
]

{ #category : #examples }
GtLMiniMaxOpenAIClientExamples >> providerNameIsMiniMax [
	<gtExample>
	<return: #Boolean>
	self assert: GtLMiniMaxOpenAIProvider providerName equals: 'MiniMax provider'.
	^ true
]
