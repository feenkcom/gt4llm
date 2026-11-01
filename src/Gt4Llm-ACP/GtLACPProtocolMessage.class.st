"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPProtocolMessage,
	#superclass : #GtLACPObject,
	#instVars : [
		'data',
		'direction',
		'timestamp'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPProtocolMessage >> data [
 ^ data
]

{ #category : #accessing }
GtLACPProtocolMessage >> data: anObject [
 data := anObject
]

{ #category : #accessing }
GtLACPProtocolMessage >> direction [
 ^ direction
]

{ #category : #accessing }
GtLACPProtocolMessage >> direction: anObject [
 direction := anObject
]

{ #category : #views }
GtLACPProtocolMessage >> gtDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Data';
		object: [ data ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLACPProtocolMessage >> gtJsonFor: aView [
	<gtView>
	^ aView textEditor
		title: 'JSON';
		priority: 30;
		text: [ STONJSON toStringPretty: data ];
		styler: JSONParser gtStyler;
		aptitude: BrGlamorousCodeEditorAptitude;
		actionUpdateButtonTooltip: 'Refresh json'
]

{ #category : #accessing }
GtLACPProtocolMessage >> id [
 ^ data at: 'id' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPProtocolMessage >> kind [
 (data includesKey: 'method') ifTrue: [
  ^ (data includesKey: 'id') ifTrue: [ #request ] ifFalse: [ #notification ] ].
 (data includesKey: 'error') ifTrue: [ ^ #error ].
 (data includesKey: 'result') ifTrue: [ ^ #response ].
 ^ #unknown
]

{ #category : #accessing }
GtLACPProtocolMessage >> operation [
 | method |
 method := data at: 'method' ifAbsent: [ ^ '' ].
 method = 'session/update' ifTrue: [
  | update |
  update := (data at: 'params' ifAbsent: [ Dictionary new ])
   at: 'update' ifAbsent: [ Dictionary new ].
  ^ method, ' · ', (update at: 'sessionUpdate' ifAbsent: [ '' ]) ].
 ^ method
]

{ #category : #accessing }
GtLACPProtocolMessage >> sessionId [
 ^ (data at: 'params' ifAbsent: [ Dictionary new ])
  at: 'sessionId' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPProtocolMessage >> summary [
 ^ direction asString, ' ', (data at: 'method' ifAbsent: [ (data includesKey: 'error') ifTrue: [ 'error' ] ifFalse: [ 'result' ] ]), ' #', (data at: 'id' ifAbsent: [ '-' ]) asString
]

{ #category : #accessing }
GtLACPProtocolMessage >> timestamp [
 ^ timestamp
]

{ #category : #accessing }
GtLACPProtocolMessage >> timestamp: anObject [
 timestamp := anObject
]
