"
I represent the assistant response to one prompt. I expose ordered tools, reasoning and commentary separately from the final reply. The prompt turn owns execution and protocol state.
"
Class {
	#name : #GtLACPAssistantMessage,
	#superclass : #GtLACPObject,
	#instVars : [
		'turn'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPAssistantMessage >> activityItems [
 | items |
 items := turn activity copy.
 ^ items first: items size - self finalMessages size
]

{ #category : #accessing }
GtLACPAssistantMessage >> finalMessages [
 | items index |
 items := turn activity copy.
 index := items size.
 [ index > 0 and: [
  ((items at: index) isKindOf: GtLACPConversationMessage) and: [
   (items at: index) role = #agent ] ] ] whileTrue: [ index := index - 1 ].
 ^ items copyFrom: index + 1 to: items size
]

{ #category : #views }
GtLACPAssistantMessage >> gtFinalReplyFor: aView [
 <gtView>
 ^ aView textEditor title: 'Final reply'; priority: 5;
  text: [ self text ]; actionUpdateButtonTooltip: 'Refresh final reply'
]

{ #category : #views }
GtLACPAssistantMessage >> gtOutcomeFor: aView [
 <gtView>
 ^ aView forward title: 'Outcome'; priority: 10; object: [ turn ]; view: #gtOutcomeFor:
]

{ #category : #views }
GtLACPAssistantMessage >> gtToolsFor: aView [
 <gtView>
 ^ aView list title: 'Tool calls'; priority: 15; items: [ self toolCalls ]; itemText: #title
]

{ #category : #views }
GtLACPAssistantMessage >> gtWorkFor: aView [
 <gtView>
 ^ aView list title: 'Tools and reasoning'; priority: 0;
  items: [ self activityItems ];
  itemText: [ :item | (item isKindOf: GtLACPToolCall)
   ifTrue: [ item title, ' · ', item status ]
   ifFalse: [ item text ] ];
  actionUpdateButtonTooltip: 'Refresh tools and reasoning'
]

{ #category : #accessing }
GtLACPAssistantMessage >> messages [
 turn activity.
 ^ turn messages copy reject: [ :each | each role = #user ]
]

{ #category : #printing }
GtLACPAssistantMessage >> printOn: aStream [
 aStream nextPutAll: 'Assistant response ('; nextPutAll: self state asString; nextPutAll: ')'
]

{ #category : #accessing }
GtLACPAssistantMessage >> role [
 ^ #assistant
]

{ #category : #accessing }
GtLACPAssistantMessage >> state [
 ^ turn state
]

{ #category : #accessing }
GtLACPAssistantMessage >> text [
 ^ String streamContents: [ :stream | self finalMessages do: [ :each | stream nextPutAll: each text ] ]
]

{ #category : #accessing }
GtLACPAssistantMessage >> toolCalls [
 ^ turn toolCalls copy
]

{ #category : #accessing }
GtLACPAssistantMessage >> turn [
 ^ turn
]

{ #category : #accessing }
GtLACPAssistantMessage >> turn: anObject [
 turn := anObject
]

{ #category : #accessing }
GtLACPAssistantMessage >> workSummary [
 | tools tool summary input otherCount |
 tools := self toolCalls.
 tools isEmpty ifTrue: [
  | text |
  text := self activityItems ifEmpty: [ '' ] ifNotEmpty: [ self activityItems last text ].
  text := (text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
  ^ text size > 140 ifTrue: [ (text first: 140), '…' ] ifFalse: [ text ] ].
 tool := tools reversed detect: [ :each | #('pending' 'in_progress' 'running') includes: each status ]
  ifNone: [ tools last ].
 summary := tool title.
 input := tool data at: 'rawInput' ifAbsent: [ nil ].
 input ifNotNil: [
  | text |
  text := STONJSON toString: input.
  text := (text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
  summary := summary, '(', (text size > 100 ifTrue: [ (text first: 100), '…' ] ifFalse: [ text ]), ')' ].
 otherCount := tools size - 1.
 otherCount > 0 ifTrue: [
  summary := summary, ' + ', otherCount asString, (otherCount = 1 ifTrue: [ ' other tool' ] ifFalse: [ ' other tools' ]) ].
 (turn permissionRequests anySatisfy: [ :each | each state = #pending ])
  ifTrue: [ summary := summary, ' · permission required' ].
 ^ summary
]
