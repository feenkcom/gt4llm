"
Optional live smoke examples. Require installed Node.js, network access to obtain adapters on first launch, and the agent's own authentication. Kept separate from deterministic GtLACPExamples.
"
Class {
	#name : #GtLACPLiveExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #'live examples' }
GtLACPLiveExamples >> claudeCodeSession [
 <gtExample>
 | session |
 session := GtLACPClaudeCodeClient new startSessionIn: FileLocator temp.
 [ self assert: session state equals: #ready ]
 ensure: [ session close ].
 ^ session
]

{ #category : #'live examples' }
GtLACPLiveExamples >> claudeCodeTurn [
 <gtExample>
 | session turn |
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
 session := GtLACPCodexClient new startSessionIn: FileLocator temp.
 [ self assert: session state equals: #ready ]
 ensure: [ session close ].
 ^ session
]

{ #category : #'live examples' }
GtLACPLiveExamples >> codexTurn [
 <gtExample>
 | session turn |
 session := GtLACPCodexClient new startSessionIn: FileLocator temp.
 [ turn := session prompt: 'Reply exactly "ACP connected". Do not use tools or change files.'.
 turn waitForSeconds: 60.
 self assert: turn state equals: #completed.
 self assert: (turn messages anySatisfy: [ :each | each role = #agent and: [ each text includesSubstring: 'ACP connected' ] ]) ]
 ensure: [ session close ].
 ^ session
]
