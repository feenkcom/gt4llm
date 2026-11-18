"
I show how configured ACP v1 system prompts are negotiated and sent over the session lifecycle using an in-memory agent.
"
Class {
	#name : #GtLACPSystemPromptExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPSystemPromptExamples >> agentWithoutSystemPromptRejectsAppend [
	<gtExample>
	| client transport failure |
	transport := self
			transportWithSessionCapabilities: {'systemPrompt' -> nil} asDictionary.
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	client configuration
		systemPrompt: (GtLACPSystemPrompt append: 'Run the tests.').
	[ [ client startSessionIn: FileLocator temp ]
		on: Error
		do: [ :anError | failure := anError messageText ].
	self assert: failure equals: 'Agent does not support system prompts'.
	self
		assert: (transport sentMessages collect: [ :each | each at: 'method' ]) asArray
		equals: #('initialize') ] ensure: [ client stop ].
	^ client
]

{ #category : #examples }
GtLACPSystemPromptExamples >> appendOnlyAgentRejectsOverride [
	<gtExample>
	| client transport failure |
	transport := self
			transportWithSessionCapabilities: {'systemPrompt' -> Dictionary new} asDictionary.
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	client configuration
		systemPrompt: (GtLACPSystemPrompt override: 'Review the changes.').
	[ [ client loadSession: 'existing-session' in: FileLocator temp ]
		on: Error
		do: [ :anError | failure := anError messageText ].
	self
		assert: failure
		equals: 'Agent does not support overriding the system prompt'.
	self
		assert: (transport sentMessages collect: [ :each | each at: 'method' ]) asArray
		equals: #('initialize') ] ensure: [ client stop ].
	^ client
]

{ #category : #examples }
GtLACPSystemPromptExamples >> appendSession [
	<gtExample>
	| client session transport parameters prompt |
	transport := self
			transportWithSessionCapabilities: {'systemPrompt' -> Dictionary new} asDictionary.
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	prompt := client configuration systemPrompt beOverride.
	prompt instructions
		addItem: 'Run the tests.';
		addItem: 'Report failures.'.
	self assert: prompt beAppend == prompt.
	[ session := client startSessionIn: FileLocator temp.
	parameters := self parametersFor: 'session/new' in: transport.
	self assert: session isReady.
	self assert: (session systemPrompt mode isKindOf: GtLACPSystemPromptAppendMode).
	self
		assert: (parameters at: 'systemPrompt')
		equals: {'mode' -> 'append'.
				'content'
					-> {{'type' -> 'text'.
								'text' -> 'Run the tests.'} asDictionary.
							{'type' -> 'text'.
								'text' -> 'Report failures.'} asDictionary}} asDictionary ]
		ensure: [ session ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ session
]

{ #category : #examples }
GtLACPSystemPromptExamples >> emptyOverrideOmitsSystemPrompt [
	<gtExample>
	| client session transport configuredPrompt |
	transport := self transportWithSessionCapabilities: Dictionary new.
	client := GtLACPClaudeCodeClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	configuredPrompt := client configuration systemPrompt.
	self assert: configuredPrompt beOverride == configuredPrompt.
	[ session := client startSessionIn: FileLocator temp.
	self assert: session isReady.
	self
		assert: (session systemPrompt mode isKindOf: GtLACPSystemPromptOverrideMode).
	self
		assert: ((self parametersFor: 'session/new' in: transport) includesKey: 'systemPrompt')
				not.
	configuredPrompt instructions addItem: 'Review the changes.'.
	self assert: session systemPrompt isEmpty ]
		ensure: [ session ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ session
]

{ #category : #fixtures }
GtLACPSystemPromptExamples >> instructionPageTitled: aTitle containing: aString [
	| page |
	page := LePage named: aTitle.
	page addSnippet: (LeTextSnippet string: aString).
	^ page
]

{ #category : #examples }
GtLACPSystemPromptExamples >> invalidSystemPromptContent [
	<gtExample>
	| failures |
	failures := {[ GtLACPSystemPrompt append: 42 ].
			[ GtLACPSystemPrompt override: nil ]}
			collect: [ :anOperation | [ anOperation value ] on: Error do: [ :anError | anError messageText ] ].
	self
		assert: failures
		equals: #('A system prompt instruction must be text' 'A system prompt instruction must be text').
	^ failures
]

{ #category : #examples }
GtLACPSystemPromptExamples >> lepiterPageExtendsClaudeCodeOverride [
	<gtExample>
	| client session transport configuredPrompt prompt blocks |
	transport := self
			transportWithSessionCapabilities: {'systemPrompt'
						-> {'mode' -> {'override' -> Dictionary new} asDictionary} asDictionary}
					asDictionary.
	client := GtLACPClaudeCodeClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	configuredPrompt := client configuration systemPrompt.
	configuredPrompt instructions addItem: 'Review the changes.'.
	configuredPrompt beOverride
		pageObjectExplanation: (self instructionPageTitled: 'Review rules' containing: 'Check the diff.').
	[ session := client startSessionIn: FileLocator temp.
	prompt := (self parametersFor: 'session/new' in: transport) at: 'systemPrompt'.
	blocks := prompt at: 'content'.
	self assert: (prompt at: 'mode') equals: 'override'.
	self assert: blocks size equals: 2.
	self assert: (blocks first at: 'text') equals: 'Review the changes.'.
	self assert: ((blocks second at: 'text') includesSubstring: 'Check the diff.').
	self assert: session systemPrompt instructions ~~ configuredPrompt instructions ]
		ensure: [ session ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ session
]

{ #category : #examples }
GtLACPSystemPromptExamples >> lepiterPagesAppendToCodexSession [
	<gtExample>
	| client configuration session transport prompt text |
	transport := self
			transportWithSessionCapabilities: {'systemPrompt' -> Dictionary new} asDictionary.
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	configuration := client configuration.
	self assert: configuration instructions isEmpty.
	self assert: configuration systemPrompt isEmpty.
	self
		assert: configuration instructions == configuration systemPrompt instructions.
	configuration
		pageObjectExplanation: (self instructionPageTitled: 'Verification' containing: 'Run the tests.');
		pageObjectExplanation: (self instructionPageTitled: 'Reporting' containing: 'Report failures.').
	self
		assert: (configuration systemPrompt mode isKindOf: GtLACPSystemPromptAppendMode).
	[ session := client startSessionIn: FileLocator temp.
	prompt := (self parametersFor: 'session/new' in: transport) at: 'systemPrompt'.
	self assert: (prompt at: 'mode') equals: 'append'.
	self assert: (prompt at: 'content') size equals: 1.
	text := (prompt at: 'content') first at: 'text'.
	self assert: (text beginsWith: '# Explanations').
	self assert: (text includesSubstring: '## Verification').
	self assert: (text includesSubstring: '## Reporting').
	self assert: (text includesSubstring: 'Run the tests.').
	self assert: (text includesSubstring: 'Report failures.').
	self
		assert: (text findString: 'Run the tests.') < (text findString: 'Report failures.') ]
		ensure: [ session ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ session
]

{ #category : #examples }
GtLACPSystemPromptExamples >> loadedSessionResendsItsSystemPrompt [
	<gtExample>
	| client session transport capabilities original loadParameters resumeParameters |
	capabilities := {'systemPrompt' -> Dictionary new.
			'resume' -> Dictionary new} asDictionary.
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport := self transportWithSessionCapabilities: capabilities ];
			yourself.
	original := GtLACPSystemPrompt append: 'Run the tests.'.
	client configuration systemPrompt: original.
	[ session := client loadSession: 'existing-session' in: FileLocator temp.
	loadParameters := self parametersFor: 'session/load' in: transport.
	self assert: (loadParameters at: 'systemPrompt') equals: original asDictionary.
	session close.
	client configuration
		systemPrompt: (GtLACPSystemPrompt append: 'Summarize the changes.').
	session reopen.
	resumeParameters := self parametersFor: 'session/resume' in: transport.
	self
		assert: (resumeParameters at: 'systemPrompt')
		equals: original asDictionary.
	self assert: (resumeParameters at: 'sessionId') equals: 'existing-session'.
	self assert: session isReady ]
		ensure: [ session ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ session
]

{ #category : #examples }
GtLACPSystemPromptExamples >> overrideSession [
	<gtExample>
	| client session transport parameters |
	transport := self
			transportWithSessionCapabilities: {'systemPrompt'
						-> {'mode' -> {'override' -> Dictionary new} asDictionary} asDictionary}
					asDictionary.
	client := GtLACPClaudeCodeClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	client configuration
		systemPrompt: (GtLACPSystemPrompt override: 'Review the changes.').
	[ session := client startSessionIn: FileLocator temp.
	parameters := self parametersFor: 'session/new' in: transport.
	self assert: session isReady.
	self
		assert: (session systemPrompt mode isKindOf: GtLACPSystemPromptOverrideMode).
	self
		assert: (parameters at: 'systemPrompt')
		equals: {'mode' -> 'override'.
				'content'
					-> {{'type' -> 'text'.
								'text' -> 'Review the changes.'} asDictionary}} asDictionary ]
		ensure: [ session ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ session
]

{ #category : #fixtures }
GtLACPSystemPromptExamples >> parametersFor: aMethod in: aTransport [
	^ (aTransport sentMessages detect: [ :each | (each at: 'method') = aMethod ])
		at: 'params'
]

{ #category : #examples }
GtLACPSystemPromptExamples >> reopenChecksTheNewAgentCapabilities [
	<gtExample>
	| client session transport capabilities failure |
	capabilities := {'systemPrompt'
				-> {'mode' -> {'override' -> Dictionary new} asDictionary} asDictionary.
			'resume' -> Dictionary new} asDictionary.
	client := GtLACPClaudeCodeClient new
			transportFactory: [ :config :directory | transport := self transportWithSessionCapabilities: capabilities ];
			yourself.
	client configuration
		systemPrompt: (GtLACPSystemPrompt override: 'Review the changes.').
	[ session := client startSessionIn: FileLocator temp.
	session close.
	capabilities := {'systemPrompt' -> Dictionary new.
			'resume' -> Dictionary new} asDictionary.
	[ session reopen ] on: Error do: [ :anError | failure := anError messageText ].
	self
		assert: failure
		equals: 'Agent does not support overriding the system prompt'.
	self
		assert: (transport sentMessages collect: [ :each | each at: 'method' ]) asArray
		equals: #('initialize').
	self assert: session isClosed ] ensure: [ client stop ].
	^ session
]

{ #category : #examples }
GtLACPSystemPromptExamples >> reopenedSessionKeepsItsLepiterInstructions [
	<gtExample>
	| client originalSession newSession transport capabilities originalPrompt newPrompt |
	capabilities := {'systemPrompt' -> Dictionary new.
			'resume' -> Dictionary new} asDictionary.
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport := self transportWithSessionCapabilities: capabilities ];
			yourself.
	client configuration
		pageObjectExplanation: (self instructionPageTitled: 'Verification' containing: 'Run the tests.').
	[ originalSession := client
			loadSession: 'existing-session'
			in: FileLocator temp.
	originalPrompt := (self parametersFor: 'session/load' in: transport)
			at: 'systemPrompt'.
	self
		assert: (((originalPrompt at: 'content') first at: 'text')
				includesSubstring: 'Run the tests.').
	originalSession close.
	client configuration
		pageObjectExplanation: (self instructionPageTitled: 'Reporting' containing: 'Report failures.').
	originalSession reopen.
	self
		assert: ((self parametersFor: 'session/resume' in: transport) at: 'systemPrompt')
		equals: originalPrompt.
	newSession := client startSessionIn: FileLocator temp.
	newPrompt := (self parametersFor: 'session/new' in: transport)
			at: 'systemPrompt'.
	self
		assert: (((newPrompt at: 'content') first at: 'text')
				includesSubstring: 'Report failures.') ]
		ensure: [ newSession ifNotNil: [ :aSession | aSession close ].
			originalSession ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ originalSession
]

{ #category : #examples }
GtLACPSystemPromptExamples >> textInstructionsUseAppendByDefault [
	<gtExample>
	| prompt initialMode |
	prompt := GtLACPSystemPrompt new.
	initialMode := prompt mode.
	self assert: (initialMode isKindOf: GtLACPSystemPromptAppendMode).
	self assert: prompt asDictionary isEmpty.
	prompt instructions addItem: 'Run the tests.'.
	self assert: prompt mode == initialMode.
	self assert: (prompt asDictionary at: 'mode') equals: 'append'.
	self assert: prompt mode == initialMode.
	^ prompt
]

{ #category : #fixtures }
GtLACPSystemPromptExamples >> transportWithSessionCapabilities: capabilityEntries [
	^ GtLACPMemoryTransport new
		responder: [ :aMessage :aTransport | 
			| method |
			method := aMessage at: 'method'.
			method = 'initialize'
				ifTrue: [ aTransport
						replyTo: aMessage
						result: {'protocolVersion' -> 1.
								'agentCapabilities'
									-> {'loadSession' -> true.
											'sessionCapabilities' -> capabilityEntries} asDictionary}
								asDictionary ].
			method = 'session/new'
				ifTrue: [ aTransport
						replyTo: aMessage
						result: {'sessionId' -> 'example-session'} asDictionary ].
			(#('session/load' 'session/resume') includes: method)
				ifTrue: [ aTransport replyTo: aMessage result: Dictionary new ] ];
		yourself
]

{ #category : #examples }
GtLACPSystemPromptExamples >> unconfiguredSessionOmitsSystemPrompt [
	<gtExample>
	| client session transport |
	transport := self transportWithSessionCapabilities: Dictionary new.
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	[ session := client startSessionIn: FileLocator temp.
	self assert: session isReady.
	self assert: session systemPrompt isEmpty.
	self assert: (session systemPrompt mode isKindOf: GtLACPSystemPromptAppendMode).
	self
		assert: ((self parametersFor: 'session/new' in: transport) includesKey: 'systemPrompt')
				not ]
		ensure: [ session ifNotNil: [ :aSession | aSession close ].
			client stop ].
	^ session
]
