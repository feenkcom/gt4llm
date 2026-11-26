"
I retain a tool call's identity and merge partial updates without discarding earlier fields. My Data view exposes the complete received payload; Input, Output and Permissions answer focused questions about its execution.
"
Class {
	#name : #GtLACPToolCall,
	#superclass : #GtLACPObject,
	#instVars : [
		'data',
		'permissionRequests',
		'elicitationRequests'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #converting }
GtLACPToolCall >> addWorkElementsTo: elements in: aWorkElement [
	elements add: (aWorkElement toolElementFor: self)
]

{ #category : #converting }
GtLACPToolCall >> asConversationTreeNode [
 ^ GtLACPToolCallTreeNode new object: self; yourself
]

{ #category : #accessing }
GtLACPToolCall >> bashCommand [
	| input |
	(data at: 'name' ifAbsent: [ nil ]) = 'Bash' ifFalse: [ ^ nil ].
	input := data at: 'rawInput' ifAbsent: [ ^ nil ].
	(input isKindOf: Dictionary) ifFalse: [ ^ nil ].
	^ (input at: 'command' ifAbsent: [ nil ])
		ifNotNil: [ :command | command isString ifTrue: [ command ] ifFalse: [ nil ] ]
]

{ #category : #converting }
GtLACPToolCall >> bashReport [
	^ GtLACPBashReport new
		toolCall: self;
		yourself
]

{ #category : #accessing }
GtLACPToolCall >> data [
 ^ data
]

{ #category : #accessing }
GtLACPToolCall >> data: anObject [
 data := anObject
]

{ #category : #accessing }
GtLACPToolCall >> elicitationRequests [
	^ elicitationRequests ifNil: [ elicitationRequests := OrderedCollection new ]
]

{ #category : #'gt - extensions' }
GtLACPToolCall >> gtBashFor: aView [
	"What Bash command was requested and what output was recorded?"

	<gtView>
	self bashCommand ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Bash';
		priority: -1;
		object: [ self bashReport ];
		view: #gtCodeAndOutputFor:
]

{ #category : #'gt - views' }
GtLACPToolCall >> gtDataFor: aView [
	"Expose the payload with the dictionary's expandable items view."

	<gtView>
	^ (data gtItemsFor: aView)
		title: 'Data';
		priority: 0;
		actionUpdateButtonTooltip: 'Refresh tool call data'
]

{ #category : #printing }
GtLACPToolCall >> gtDisplayOn: aStream [
	aStream nextPutAll: self summary
]

{ #category : #'gt - extensions' }
GtLACPToolCall >> gtInputFor: aView [
	"What input arguments were supplied to this tool call?"

	<gtView>
	^ aView textEditor
		title: 'Input';
		priority: 20.1;
		text: [ STONJSON toStringPretty: (data at: 'rawInput' ifAbsent: [ nil ]) ];
		actionUpdateButtonTooltip: 'Refresh input'
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
      background: element theme default contentBackground;
      margin: (BlInsets all: 10) ] ]
]

{ #category : #'gt - extensions' }
GtLACPToolCall >> gtOutputFor: aView [
	"What output was recorded? Preserve strings without an extra JSON encoding layer."

	<gtView>
	^ aView textEditor
		title: 'Output';
		priority: 20.2;
		text: [ | output |
			output := data
					at: 'rawOutput'
					ifAbsent: [ data at: 'content' ifAbsent: [ nil ] ].
			output isString
				ifTrue: [ output ]
				ifFalse: [ STONJSON toStringPretty: output ] ];
		actionUpdateButtonTooltip: 'Refresh output'
]

{ #category : #views }
GtLACPToolCall >> gtPermissionsFor: aView [
	<gtView>
	
	^ aView list
		title: 'Permissions';
		priority: 25;
		items: [ permissionRequests copy ];
		itemText: #yourself;
		actionUpdateButtonTooltip: 'Refresh permissions'
]

{ #category : #views }
GtLACPToolCall >> gtQuestionsFor: aView [
	<gtView>
	^ aView list
		title: 'Questions';
		priority: 35;
		items: [ self elicitationRequests ];
		itemText: #message
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
 | text |
 text := self
  withMcpToolCallIfPresent: [ :message | message toolCall gtDisplayString ]
  ifAbsent: [
   | input description |
   description := self title.
   input := data at: 'rawInput' ifAbsent: [ nil ].
   input ifNotNil: [ description := description, '(', (STONJSON toString: input), ')' ].
   description ].
 text := (text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
 ^ text size > 80 ifTrue: [ (text first: 79), '…' ] ifFalse: [ text ]
]

{ #category : #accessing }
GtLACPToolCall >> status [
 ^ data at: 'status' ifAbsent: [ 'pending' ]
]

{ #category : #building }
GtLACPToolCall >> summary [
	| summary |
	summary := self shortDescription.
	(#('in_progress' 'running') includes: self status)
		ifTrue: [ summary := summary , ' · working' ].
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
	^ (self mcpToolMessageIn: GtLACPSession mcpServer)
		ifNotNil: aPresentBlock
		ifNil: anAbsentBlock
]

{ #category : #accessing }
GtLACPToolCall >> workSummaryText [
 ^ self shortDescription
]
