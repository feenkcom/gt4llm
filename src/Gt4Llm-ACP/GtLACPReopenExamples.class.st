"
Executable examples for reopening an existing ACP session through session/resume. In-memory transports verify preserved session, connection, turn, message, tool and subagent identities; authentication and MCP parameters; registry subscriptions; shared connections; and cleanup and retries after initialization or resume failures. No installed agents or network access are required.
"
Class {
	#name : #GtLACPReopenExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #fixtures }
GtLACPReopenExamples >> client [
	^ self
		clientWithResume: true
		onResume: [ :message :transport | 
			transport
				replyTo: message
				result: {'modes' -> {'currentModeId' -> 'resumed-mode'} asDictionary} asDictionary ]
]

{ #category : #fixtures }
GtLACPReopenExamples >> clientWithResume: supportsResume onResume: resumeBlock [
	^ GtLACPCodexClient new
		transportFactory: [ :configuration :directory | self transportWithResume: supportsResume onResume: resumeBlock ];
		yourself
]

{ #category : #examples }
GtLACPReopenExamples >> failedReopenCanBeRetried [
	<gtExample>
	| client session turn failed |
	failed := true.
	client := self
			clientWithResume: true
			onResume: [ :message :transport | 
				failed
					ifTrue: [ transport
							receive: {'jsonrpc' -> '2.0'.
									'id' -> (message at: 'id').
									'error'
										-> {'code' -> -32603.
												'message' -> 'Resume failed'} asDictionary} asDictionary ]
					ifFalse: [ transport replyTo: message result: Dictionary new ] ].
	session := client startSessionIn: FileLocator temp.
	[ turn := session prompt: 'Keep this'.
	session close.
	self
		assert: ([ session reopen.
			false ]
				on: Error
				do: [ :error | error messageText includesSubstring: 'Resume failed' ]).
	self assert: session isClosed.
	self assert: session connection state equals: #stopped.
	self assert: session connection sessions isEmpty.
	self assert: session connection pendingRequests isEmpty.
	self assert: session turns first == turn.
	failed := false.
	self assert: session reopen == session.
	self assert: session isReady.
	self assert: session turns first == turn ] ensure: [ client stop ].
	^ session
]

{ #category : #examples }
GtLACPReopenExamples >> failedReopenPreservesOtherSessions [
	<gtExample>
	| client first second connection |
	client := self
			clientWithResume: true
			onResume: [ :message :transport | 
				transport
					receive: {'jsonrpc' -> '2.0'.
							'id' -> (message at: 'id').
							'error'
								-> {'code' -> -32603.
										'message' -> 'Resume failed'} asDictionary} asDictionary ].
	first := client startSessionIn: FileLocator temp.
	connection := first connection.
	second := client newSessionIn: FileLocator temp connection: connection.
	second create.
	[ first close.
	GtLACPExamples new assertRaisesError: [ first reopen ] raise: Error.
	self assert: first isClosed.
	self assert: second isReady.
	self assert: connection state equals: #ready.
	self assert: connection sessions size equals: 1.
	self assert: connection pendingRequests isEmpty.
	self assert: (connection sessions at: second remoteSessionId) == second.
	self assert: (second prompt: 'Still connected') isCompleted ]
		ensure: [ client stop ].
	^ first
]

{ #category : #examples }
GtLACPReopenExamples >> reopenInitializationFailureCanBeRetried [
	<gtExample>
	| client session turn transport |
	client := self client.
	session := client startSessionIn: FileLocator temp.
	turn := session prompt: 'Keep history'.
	session close.
	client
		transportFactory: [ :configuration :directory | 
			GtLACPMemoryTransport new
				responder: [ :message :memory | 
					memory
						receive: {'jsonrpc' -> '2.0'.
								'id' -> (message at: 'id').
								'error'
									-> {'code' -> -32603.
											'message' -> 'Initialize failed'} asDictionary} asDictionary ];
				yourself ].
	self
		assert: ([ session reopen.
			false ]
				on: Error
				do: [ :error | error messageText includesSubstring: 'Initialize failed' ]).
	self assert: session isClosed.
	self assert: session connection state equals: #stopped.
	self assert: session connection sessions isEmpty.
	self assert: session connection pendingRequests isEmpty.
	self assert: session turns first == turn.
	transport := session connection transport.
	client
		transportFactory: [ :configuration :directory | 
			self
				transportWithResume: true
				onResume: [ :message :memory | memory replyTo: message result: Dictionary new ] ].
	[ session reopen.
	self assert: session isReady.
	self assert: session connection transport ~~ transport.
	self assert: session turns first == turn ] ensure: [ client stop ].
	^ session
]

{ #category : #examples }
GtLACPReopenExamples >> reopenKeepsRegistrySubscriptions [
	<gtExample>
	| registry client session count |
	registry := GtLACPSessionRegistry new.
	client := self client.
	session := registry newSessionWithClient: client in: FileLocator temp.
	count := 0.
	registry announcer
		when: GtLACPSessionRegistryChanged
		do: [ :announcement | count := count + 1 ]
		for: self.
	[ session close.
	count := 0.
	session reopen.
	self assert: count > 0.
	self assert: registry sessions size equals: 1.
	self assert: registry sessions first == session.
	count := 0.
	session connection announceConversationTreeChanged.
	self assert: count equals: 1 ]
		ensure: [ client stop.
			registry clearSessions ].
	^ session
]

{ #category : #examples }
GtLACPReopenExamples >> reopenPreservesConversationIdentity [
	<gtExample>
	| client session connection transport turns turn user assistant tool identifier result |
	client := self client.
	session := client startSessionIn: FileLocator temp.
	[ turn := session prompt: 'Hello'.
	user := turn userMessages first.
	assistant := turn assistantMessage.
	tool := turn toolCalls first.
	turns := session turns.
	connection := session connection.
	transport := connection transport.
	identifier := session remoteSessionId.
	session close.
	result := session reopen.
	self assert: result == session.
	self assert: session connection == connection.
	self assert: connection transport ~~ transport.
	self assert: session turns == turns.
	self assert: session turns size equals: 1.
	self assert: session turns first == turn.
	self assert: turn userMessages first == user.
	self assert: turn assistantMessage == assistant.
	self assert: turn toolCalls first == tool.
	self assert: session remoteSessionId equals: identifier.
	self assert: session isReady.
	self assert: connection lastError isNil.
	self assert: (session modes at: 'currentModeId') equals: 'resumed-mode'.
	self assert: client sessions size equals: 1.
	self assert: client connections size equals: 1.
	self assert: (connection sessions at: identifier) == session.
	self
		assert: (connection transport sentMessages collect: [ :each | each at: 'method' ])
		equals: #('initialize' 'session/resume') asOrderedCollection.
	self
		assert: ([ session reopen.
			false ]
				on: Error
				do: [ :error | error messageText = 'Only a closed session can be reopened' ]).
	self assert: session isReady.
	self assert: connection transport sentMessages size equals: 2.
	self assert: (session prompt: 'Continue') isCompleted.
	self assert: session turns size equals: 2 ] ensure: [ client stop ].
	^ session
]

{ #category : #examples }
GtLACPReopenExamples >> reopenPreservesSharedConnection [
	<gtExample>
	| client first second connection transport |
	client := self client.
	first := client startSessionIn: FileLocator temp.
	connection := first connection.
	second := client newSessionIn: FileLocator temp connection: connection.
	second create.
	[ transport := connection transport.
	first close.
	self assert: connection state equals: #ready.
	first reopen.
	self assert: connection transport == transport.
	self assert: second isReady.
	self assert: (connection sessions at: second remoteSessionId) == second.
	self assert: connection sessions size equals: 2.
	self assert: (second prompt: 'Still connected') isCompleted.
	self assert: (first prompt: 'Reconnected') isCompleted ]
		ensure: [ client stop ].
	^ first
]

{ #category : #examples }
GtLACPReopenExamples >> reopenRefreshesAuthenticationAndParameters [
	<gtExample>
	| client session mcpServer request methods |
	client := self client.
	mcpServer := {'name' -> 'image'.
			'type' -> 'http'.
			'url' -> 'http://localhost:3000/'.
			'headers' -> #()} asDictionary.
	client configuration
		authenticationMethod: 'fixture-auth';
		requestTimeout: 180;
		mcpServers: {mcpServer}.
	session := client startSessionIn: FileLocator temp.
	[ session close.
	session reopen.
	methods := session connection transport sentMessages
			collect: [ :each | each at: 'method' ].
	self
		assert: methods
		equals: #('initialize' 'authenticate' 'session/resume') asOrderedCollection.
	self assert: session connection requestTimeout equals: 180.
	request := session connection transport sentMessages last at: 'params'.
	self assert: (request at: 'sessionId') equals: session remoteSessionId.
	self assert: (request at: 'cwd') equals: session directory fullName.
	self assert: (request at: 'mcpServers') equals: {mcpServer} ]
		ensure: [ client stop ].
	^ session
]

{ #category : #examples }
GtLACPReopenExamples >> reopenRejectsUnstartedOrMissingDirectory [
	<gtExample>
	| client session transport |
	GtLACPExamples new assertRaisesError: [ GtLACPSession new reopen ] raise: Error.
	client := self client.
	session := client startSessionIn: FileLocator temp.
	session close.
	transport := session connection transport.
	session directory: FileSystem memory root / 'absent'.
	self
		assert: ([ session reopen.
			false ]
				on: Error
				do: [ :error | error messageText = 'Session directory must exist' ]).
	self assert: session isClosed.
	self assert: session connection transport == transport.
	^ session
]

{ #category : #examples }
GtLACPReopenExamples >> reopenRestoresChildRouting [
	<gtExample>
	| client session child grandchild turn childTurn |
	client := self client.
	session := client startSessionIn: FileLocator temp.
	[ turn := session prompt: 'Delegate'.
	child := (session
			receiveSubagentUpdate: {'sessionId' -> 'child'.
					'title' -> 'Worker'} asDictionary) session.
	grandchild := (child
			receiveSubagentUpdate: {'sessionId' -> 'grandchild'.
					'title' -> 'Nested worker'} asDictionary) session.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text' -> 'Existing child history'} asDictionary} asDictionary
		to: child.
	childTurn := child currentTurn.
	session close.
	session reopen.
	self assert: session childSessions first == child.
	self assert: child childSessions first == grandchild.
	self assert: child currentTurn == childTurn.
	self assert: child parentSubagent parentSession == session.
	self assert: child connection == session connection.
	self assert: grandchild connection == session connection.
	self assert: (session connection sessions at: 'child') == child.
	self assert: (session connection sessions at: 'grandchild') == grandchild.
	self assert: child parentSubagent workState equals: #unconfirmed.
	self assert: child parentSubagent canCancel not.
	GtLACPExamples new assertRaisesError: [ child reopen ] raise: Error.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'subagent_update'.
				'sessionId' -> 'child'.
				'state' -> {'state' -> 'running'} asDictionary.
				'capabilities' -> {'cancel' -> Dictionary new} asDictionary} asDictionary
		to: session.
	self assert: session childSessions size equals: 1.
	self assert: child parentSubagent canCancel.
	self assert: session turns first == turn ] ensure: [ client stop ].
	^ session
]

{ #category : #fixtures }
GtLACPReopenExamples >> transportWithResume: supportsResume onResume: resumeBlock [
	^ GtLACPMemoryTransport new
		responder: [ :message :transport | 
			| method capabilities parameters |
			method := message at: 'method' ifAbsent: [ '' ].
			method = 'initialize'
				ifTrue: [ capabilities := Dictionary new.
					supportsResume
						ifTrue: [ capabilities
								at: 'sessionCapabilities'
								put: {'resume' -> Dictionary new} asDictionary ].
					transport
						replyTo: message
						result: {'protocolVersion' -> 1.
								'agentCapabilities' -> capabilities.
								'authMethods' -> {{'id' -> 'fixture-auth'} asDictionary}} asDictionary ].
			method = 'authenticate'
				ifTrue: [ transport replyTo: message result: Dictionary new ].
			method = 'session/new'
				ifTrue: [ transport
						replyTo: message
						result: {'sessionId' -> ('session-' , (message at: 'id') asString)} asDictionary ].
			method = 'session/resume'
				ifTrue: [ resumeBlock value: message value: transport ].
			method = 'session/prompt'
				ifTrue: [ parameters := message at: 'params'.
					transport
						receive: {'jsonrpc' -> '2.0'.
								'method' -> 'session/update'.
								'params'
									-> {'sessionId' -> (parameters at: 'sessionId').
											'update'
												-> {'sessionUpdate' -> 'tool_call'.
														'toolCallId' -> 'fixture-tool'.
														'title' -> 'Read project'.
														'status' -> 'completed'} asDictionary} asDictionary} asDictionary.
					transport
						receive: {'jsonrpc' -> '2.0'.
								'method' -> 'session/update'.
								'params'
									-> {'sessionId' -> (parameters at: 'sessionId').
											'update'
												-> {'sessionUpdate' -> 'agent_message_chunk'.
														'content'
															-> {'type' -> 'text'.
																	'text' -> 'Reply'} asDictionary} asDictionary} asDictionary}
								asDictionary.
					transport
						replyTo: message
						result: {'stopReason' -> 'end_turn'} asDictionary ] ];
		yourself
]

{ #category : #examples }
GtLACPReopenExamples >> unsupportedResumePreservesHistory [
	<gtExample>
	| client session turn |
	client := self
			clientWithResume: false
			onResume: [ :message :transport | self error: 'Resume must not be sent' ].
	session := client startSessionIn: FileLocator temp.
	[ turn := session prompt: 'Keep this'.
	session close.
	self
		assert: ([ session reopen.
			false ]
				on: Error
				do: [ :error | error messageText includesSubstring: 'does not support resuming' ]).
	self assert: session isClosed.
	self assert: session turns first == turn.
	self assert: session connection state equals: #stopped.
	self assert: session connection pendingRequests isEmpty.
	self
		assert: (session connection transport sentMessages
				collect: [ :each | each at: 'method' ])
		equals: #('initialize') asOrderedCollection ] ensure: [ client stop ].
	^ session
]
