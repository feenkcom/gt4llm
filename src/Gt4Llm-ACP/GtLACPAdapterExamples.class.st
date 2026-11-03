"
I exercise adapter selection, preserved agent preferences, effective launch settings and language-independent ACP sessions using in-image transports.
"
Class {
	#name : #GtLACPAdapterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPAdapterExamples >> adapterViews [
	<gtExample>
	| configuration |
	configuration := self pythonConfiguration.
	{configuration.
		configuration adapter.
		GtLACPNpmAdapter package: '@agentclientprotocol/claude-agent-acp'}
		do: [ :object | GtLACPChatExamples new assertObjectPhlowViewsFor: object ].
	^ configuration
]

{ #category : #examples }
GtLACPAdapterExamples >> defaultAdapters [
	<gtExample>
	| claude codex |
	claude := GtLACPClaudeCodeClient new configuration.
	codex := GtLACPCodexClient new configuration.
	self assert: claude executable equals: 'npx'.
	self
		assert: claude arguments
		equals: #('--yes' '@agentclientprotocol/claude-agent-acp').
	self
		assert: codex arguments
		equals: #('--yes' '@agentclientprotocol/codex-acp').
	^ {claude adapter.
		codex adapter}
]

{ #category : #examples }
GtLACPAdapterExamples >> installedPythonExecutable [
	<gtExample>
	| configuration |
	configuration := self pythonConfiguration.
	configuration
		executable: '/custom/bin/claude-code-acp';
		arguments: #().
	configuration validate.
	self assert: configuration executable equals: '/custom/bin/claude-code-acp'.
	self assert: configuration arguments isEmpty.
	^ configuration
]

{ #category : #examples }
GtLACPAdapterExamples >> pythonAdapterConversation [
	<gtExample>
	| session turn |
	session := self pythonAdapterSession.
	turn := session prompt: 'Hello from Python adapter configuration'.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text' -> 'Hello from the ACP fixture'} asDictionary} asDictionary
		to: session.
	session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary.
	self assert: turn state equals: #completed.
	self assert: turn assistantMessage text equals: 'Hello from the ACP fixture'.
	^ session
]

{ #category : #examples }
GtLACPAdapterExamples >> pythonAdapterSession [
	<gtExample>
	| client session configurationUsed directoryUsed |
	client := GtLACPClaudeCodeClient new.
	client configuration adapter: GtLACPClaudeCodePythonAdapter new.
	client
		transportFactory: [ :configuration :directory | 
			configurationUsed := configuration.
			directoryUsed := directory.
			GtLACPExamples new transport ].
	session := client startSessionIn: FileLocator temp.
	self assert: configurationUsed == client configuration.
	self assert: directoryUsed equals: FileLocator temp asFileReference asAbsolute.
	self assert: session state equals: #ready.
	self assert: session client == client.
	self assert: session connection state equals: #ready.
	^ session
]

{ #category : #examples }
GtLACPAdapterExamples >> pythonConfiguration [
	<gtExample>
	| configuration |
	configuration := GtLACPClaudeCodeClientConfiguration new
			adapter: GtLACPClaudeCodePythonAdapter new;
			yourself.
	self assert: configuration executable equals: 'uvx'.
	self
		assert: configuration arguments
		equals: #('--from' 'claude-code-acp==0.5.1' '--with' 'agent-client-protocol==0.7.0' 'claude-code-acp').
	configuration validate.
	^ configuration
]

{ #category : #examples }
GtLACPAdapterExamples >> pythonLaunchDisplayed [
	<gtExample>
	| configuration scripter |
	configuration := self pythonConfiguration.
	scripter := BlScripter new
			extent: 1000 @ 500;
			model: configuration;
			element: ((configuration gtLaunchFor: GtPhlowView empty)
					asElementDo: [ :element | element ]);
			yourself.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'uvx';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'Claude Code (Python)';
				exists ].
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAdapterExamples >> switchingAdapterPreservesPreferences [
	<gtExample>
	| configuration environment servers |
	environment := {'EXAMPLE_SETTING' -> 'example'} asDictionary.
	servers := {{'name' -> 'fixture'.
				'command' -> 'fixture-server'.
				'args' -> #().
				'env' -> #()} asDictionary}.
	configuration := GtLACPClaudeCodeClientConfiguration new
			model: 'fixture-model';
			mode: 'plan';
			requestTimeout: 45;
			environment: environment;
			mcpServers: servers;
			executable: '/custom/npx';
			arguments: #('custom');
			adapter: GtLACPClaudeCodePythonAdapter new;
			yourself.
	self assert: configuration executable equals: 'uvx'.
	self assert: configuration model equals: 'fixture-model'.
	self assert: configuration mode equals: 'plan'.
	self assert: configuration environment == environment.
	self assert: configuration mcpServers == servers.
	self assert: configuration requestTimeout equals: 45.
	^ configuration
]
