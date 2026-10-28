"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPMemoryTransport,
	#superclass : #GtLACPTransport,
	#instVars : [
		'sentMessages',
		'responder'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #views }
GtLACPMemoryTransport >> gtSentMessagesFor: aView [
 <gtView>
 ^ aView columnedList title: 'Sent messages'; priority: 0;
  items: [ sentMessages copy ];
  column: 'Method' text: [ :each | each at: 'method' ifAbsent: [ 'response' ] ];
  column: 'ID' text: [ :each | (each at: 'id' ifAbsent: [ '-' ]) asString ];
  actionUpdateButtonTooltip: 'Refresh sent messages'
]

{ #category : #accessing }
GtLACPMemoryTransport >> initialize [
 super initialize.
 sentMessages := OrderedCollection new.
 responder := [ :message :aTransport | ]
]

{ #category : #io }
GtLACPMemoryTransport >> receive: aDictionary [
 connection receive: aDictionary
]

{ #category : #io }
GtLACPMemoryTransport >> replyTo: aDictionary result: aResult [
 self receive: { 'jsonrpc' -> '2.0'. 'id' -> (aDictionary at: 'id'). 'result' -> aResult } asDictionary
]

{ #category : #accessing }
GtLACPMemoryTransport >> responder [
 ^ responder
]

{ #category : #accessing }
GtLACPMemoryTransport >> responder: anObject [
 responder := anObject
]

{ #category : #io }
GtLACPMemoryTransport >> send: aDictionary [
 state = #running ifFalse: [ self error: 'Transport is not running' ].
 sentMessages add: aDictionary.
 responder value: aDictionary value: self
]

{ #category : #accessing }
GtLACPMemoryTransport >> sentMessages [
 ^ sentMessages
]

{ #category : #accessing }
GtLACPMemoryTransport >> sentMessages: anObject [
 sentMessages := anObject
]

{ #category : #lifecycle }
GtLACPMemoryTransport >> start [
 state := #running
]
