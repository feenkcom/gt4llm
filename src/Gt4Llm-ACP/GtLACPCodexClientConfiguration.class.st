"
I hold Codex-specific launch settings and initial session preferences. My Launch, Environment overrides, Session preferences and MCP servers views describe how Codex will be started. The environment view lists override names without exposing their values.
"
Class {
	#name : #GtLACPCodexClientConfiguration,
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
GtLACPCodexClientConfiguration >> arguments [
 ^ arguments
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> arguments: anObject [
 arguments := anObject
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> authenticationMethod [
 ^ authenticationMethod
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> authenticationMethod: anObject [
 authenticationMethod := anObject
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> environment [
 ^ environment
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> environment: anObject [
 environment := anObject
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> executable [
 ^ executable
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> executable: anObject [
 executable := anObject
]

{ #category : #views }
GtLACPCodexClientConfiguration >> gtEnvironmentFor: aView [
 <gtView>
 ^ aView list title: 'Environment overrides'; priority: 10;
  items: [ environment keys sorted ];
  itemText: #yourself
]

{ #category : #views }
GtLACPCodexClientConfiguration >> gtLaunchFor: aView [
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
GtLACPCodexClientConfiguration >> gtMcpServersFor: aView [
 <gtView>
 ^ aView list title: 'MCP servers'; priority: 15; items: [ mcpServers ];
  itemText: [ :server | server at: 'name' ifAbsent: [ server printString ] ]
]

{ #category : #views }
GtLACPCodexClientConfiguration >> gtPreferencesFor: aView [
 <gtView>
 ^ aView columnedList title: 'Session preferences'; priority: 5;
  items: [ { 'Model' -> model. 'Mode' -> mode. 'Authentication method' -> authenticationMethod } ];
  column: 'Preference' text: #key;
  column: 'Requested value' text: [ :entry | entry value printString ];
  send: #value
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> initialize [
 super initialize.
 executable := 'npx'.
 arguments := #('--yes' '@agentclientprotocol/codex-acp').
 environment := Dictionary new.
 requestTimeout := 30.
 mcpServers := #()
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> mcpServers [
 ^ mcpServers
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> mcpServers: anObject [
 mcpServers := anObject
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> mode [
 ^ mode
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> mode: anObject [
 mode := anObject
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> model [
 ^ model
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> model: anObject [
 model := anObject
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> requestTimeout [
 ^ requestTimeout
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> requestTimeout: anObject [
 requestTimeout := anObject
]

{ #category : #accessing }
GtLACPCodexClientConfiguration >> validate [
 executable isEmptyOrNil ifTrue: [ self error: 'An ACP adapter executable is required' ].
 requestTimeout > 0 ifFalse: [ self error: 'Request timeout must be positive' ]
]
