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
GtLACPProtocolMessage >> gtJsonFor: aView [
 <gtView>
 ^ aView textEditor title: 'JSON'; priority: 30; text: [ STONJSON toStringPretty: data ]; actionUpdateButtonTooltip: 'Refresh json'
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
