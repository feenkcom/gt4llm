"
I retain a tool call's identity and merge partial updates without discarding earlier fields. My Data view exposes the complete received payload; Input, Output and Permissions answer focused questions about its execution.
"
Class {
	#name : #GtLACPToolCall,
	#superclass : #GtLACPObject,
	#instVars : [
		'data',
		'permissionRequests'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPToolCall >> data [
 ^ data
]

{ #category : #accessing }
GtLACPToolCall >> data: anObject [
 data := anObject
]

{ #category : #views }
GtLACPToolCall >> gtDataFor: aView [
 <gtView>
 ^ aView columnedList title: 'Data'; priority: 0;
  items: [ data keys sorted collect: [ :key | key -> (data at: key) ] ];
  column: 'Field' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh tool call data'
]

{ #category : #views }
GtLACPToolCall >> gtInputFor: aView [
 <gtView>
 ^ aView textEditor title: 'Input'; priority: 20; text: [ STONJSON toStringPretty: (data at: 'rawInput' ifAbsent: [ nil ]) ]; actionUpdateButtonTooltip: 'Refresh input'
]

{ #category : #views }
GtLACPToolCall >> gtMcpToolMessageFor: aView [
 <gtView>
 self hasCorrespondingMcpToolCall ifFalse: [ ^ aView empty ].
 ^ aView explicit
  title: 'MCP tool message';
  priority: -10;
  stencil: [
   (self mcpToolMessage gtViewsFor: GtPhlowView empty)
    asElementDo: [ :element |
     element
      addAptitude: BrShadowAptitude new;
      background: Color white;
      margin: (BlInsets all: 10) ] ]
]

{ #category : #views }
GtLACPToolCall >> gtOutputFor: aView [
 <gtView>
 ^ aView textEditor title: 'Output'; priority: 20; text: [ STONJSON toStringPretty: (data at: 'rawOutput' ifAbsent: [ data at: 'content' ifAbsent: [ nil ] ]) ]; actionUpdateButtonTooltip: 'Refresh output'
]

{ #category : #views }
GtLACPToolCall >> gtPermissionsFor: aView [
 <gtView>
 ^ aView list title: 'Permissions'; priority: 20; items: [ permissionRequests copy ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh permissions'
]

{ #category : #testing }
GtLACPToolCall >> hasCorrespondingMcpToolCall [
 ^ self
  withMcpToolCallIfPresent: [ :message | true ]
  ifAbsent: [ false ]
]

{ #category : #accessing }
GtLACPToolCall >> id [
 ^ data at: 'toolCallId' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPToolCall >> initialize [
 super initialize.
 data := Dictionary new.
 permissionRequests := OrderedCollection new
]

{ #category : #accessing }
GtLACPToolCall >> mcpToolMessage [
 ^ self
  withMcpToolCallIfPresent: [ :message | message ]
  ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPToolCall >> mcpToolMessageIn: aServer [
 | toolCallId |
 aServer ifNil: [ ^ nil ].
 toolCallId := self id.
 toolCallId ifNil: [ ^ nil ].
 ^ aServer historySnapshot
  detect: [ :each | each toolCall id = toolCallId ]
  ifNone: [ nil ]
]

{ #category : #accessing }
GtLACPToolCall >> permissionRequests [
 ^ permissionRequests
]

{ #category : #accessing }
GtLACPToolCall >> permissionRequests: anObject [
 permissionRequests := anObject
]

{ #category : #accessing }
GtLACPToolCall >> shortDescription [
 | text input |
 text := self title.
 input := data at: 'rawInput' ifAbsent: [ nil ].
 input ifNotNil: [ text := text, '(', (STONJSON toString: input), ')' ].
 text := (text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
 ^ text size > 80 ifTrue: [ (text first: 79), '…' ] ifFalse: [ text ]
]

{ #category : #accessing }
GtLACPToolCall >> status [
 ^ data at: 'status' ifAbsent: [ 'pending' ]
]

{ #category : #accessing }
GtLACPToolCall >> summary [
 | summary |
 summary := self shortDescription.
 (#('in_progress' 'running') includes: self status)
  ifTrue: [ summary := summary, ' · working' ].
 (permissionRequests anySatisfy: [ :request | request state = #pending ])
  ifTrue: [ summary := summary, ' · permission required' ].
 ^ summary
]

{ #category : #accessing }
GtLACPToolCall >> title [
 ^ data at: 'title' ifAbsent: [ self id ]
]

{ #category : #updates }
GtLACPToolCall >> updateFrom: aDictionary [
 aDictionary keysAndValuesDo: [ :key :value | data at: key put: value ]
]

{ #category : #accessing }
GtLACPToolCall >> withMcpToolCallIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
 ^ (self mcpToolMessageIn: GtLMcpServer current)
  ifNotNil: aPresentBlock
  ifNil: anAbsentBlock
]
