"
I hold Claude Code-specific launch settings and initial session preferences. My Launch, Environment overrides, Session preferences and MCP servers views describe how Claude Code will be started. The environment view lists override names without exposing their values.
"
Class {
	#name : #GtLACPClaudeCodeClientConfiguration,
	#superclass : #GtLACPObject,
	#instVars : [
		'executable',
		'arguments',
		'environment',
		'requestTimeout',
		'mcpServers',
		'model',
		'mode',
		'authenticationMethod'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> arguments [
 ^ arguments
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> arguments: anObject [
 arguments := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> authenticationMethod [
 ^ authenticationMethod
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> authenticationMethod: anObject [
 authenticationMethod := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> environment [
 ^ environment
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> environment: anObject [
 environment := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> executable [
 ^ executable
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> executable: anObject [
 executable := anObject
]

{ #category : #views }
GtLACPClaudeCodeClientConfiguration >> gtEnvironmentFor: aView [
 <gtView>
 ^ aView list title: 'Environment overrides'; priority: 10;
  items: [ environment keys sorted ];
  itemText: #yourself
]

{ #category : #views }
GtLACPClaudeCodeClientConfiguration >> gtLaunchFor: aView [
 <gtView>
 ^ aView columnedList title: 'Launch'; priority: 0;
  items: [ {
   'Executable' -> executable.
   'Arguments' -> arguments.
   'Request timeout (seconds)' -> requestTimeout } ];
  column: 'Launch setting' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value
]

{ #category : #views }
GtLACPClaudeCodeClientConfiguration >> gtMcpServersFor: aView [
 <gtView>
 ^ aView list title: 'MCP servers'; priority: 15; items: [ mcpServers ];
  itemText: [ :server | server at: 'name' ifAbsent: [ server printString ] ]
]

{ #category : #views }
GtLACPClaudeCodeClientConfiguration >> gtPreferencesFor: aView [
 <gtView>
 ^ aView columnedList title: 'Session preferences'; priority: 5;
  items: [ { 'Model' -> model. 'Mode' -> mode. 'Authentication method' -> authenticationMethod } ];
  column: 'Preference' text: #key;
  column: 'Requested value' text: [ :entry | entry value printString ];
  send: #value
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> initialize [
 super initialize.
 executable := 'npx'.
 arguments := #('--yes' '@agentclientprotocol/claude-agent-acp').
 environment := Dictionary new.
 requestTimeout := 30.
 mcpServers := #()
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> mcpServers [
 ^ mcpServers
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> mcpServers: anObject [
 mcpServers := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> mode [
 ^ mode
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> mode: anObject [
 mode := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> model [
 ^ model
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> model: anObject [
 model := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> requestTimeout [
 ^ requestTimeout
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> requestTimeout: anObject [
 requestTimeout := anObject
]

{ #category : #accessing }
GtLACPClaudeCodeClientConfiguration >> validate [
 executable isEmptyOrNil ifTrue: [ self error: 'An ACP adapter executable is required' ].
 requestTimeout > 0 ifFalse: [ self error: 'Request timeout must be positive' ]
]
