"
Optional live smoke examples for real Codex and Claude Code adapters. Disabled by default. Enable explicitly with GtLACPLiveExamples enabled: true; disable with enabled: false. When disabled, examples return before launching agents. Kept separate from deterministic GtLACPExamples.
"
Class {
	#name : #GtLACPLiveExamples,
	#superclass : #Object,
	#classInstVars : [
		'enabled'
	],
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #accessing }
GtLACPLiveExamples class >> enabled [
 ^ enabled
]

{ #category : #accessing }
GtLACPLiveExamples class >> enabled: aBoolean [
 enabled := aBoolean
]

{ #category : #initialization }
GtLACPLiveExamples class >> initialize [
 super initialize.
 enabled := false
]

{ #category : #'live examples' }
GtLACPLiveExamples >> claudeCodeSession [
 <gtExample>
 | session |
 self class enabled ifFalse: [ ^ nil ].
 session := GtLACPClaudeCodeClient new startSessionIn: FileLocator temp.
 [ self assert: session state equals: #ready ]
 ensure: [ session close ].
 ^ session
]

{ #category : #'live examples' }
GtLACPLiveExamples >> claudeCodeTurn [
 <gtExample>
 | session turn |
 self class enabled ifFalse: [ ^ nil ].
 session := GtLACPClaudeCodeClient new startSessionIn: FileLocator temp.
 [ turn := session prompt: 'Reply exactly "ACP connected". Do not use tools or change files.'.
 turn waitForSeconds: 60.
 self assert: turn state equals: #completed.
 self assert: (turn messages anySatisfy: [ :each | each role = #agent and: [ each text includesSubstring: 'ACP connected' ] ]) ]
 ensure: [ session close ].
 ^ session
]

{ #category : #'live examples' }
GtLACPLiveExamples >> codexSession [
 <gtExample>
 | session |
 self class enabled ifFalse: [ ^ nil ].
 session := GtLACPCodexClient new startSessionIn: FileLocator temp.
 [ self assert: session state equals: #ready ]
 ensure: [ session close ].
 ^ session
]

{ #category : #'live examples' }
GtLACPLiveExamples >> codexTurn [
 <gtExample>
 | session turn |
 self class enabled ifFalse: [ ^ nil ].
 session := GtLACPCodexClient new startSessionIn: FileLocator temp.
 [ turn := session prompt: 'Reply exactly "ACP connected". Do not use tools or change files.'.
 turn waitForSeconds: 60.
 self assert: turn state equals: #completed.
 self assert: (turn messages anySatisfy: [ :each | each role = #agent and: [ each text includesSubstring: 'ACP connected' ] ]) ]
 ensure: [ session close ].
 ^ session
]
