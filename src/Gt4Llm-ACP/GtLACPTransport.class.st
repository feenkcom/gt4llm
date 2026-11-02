"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPTransport,
	#superclass : #GtLACPObject,
	#instVars : [
		'connection',
		'state'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #lifecycle }
GtLACPTransport >> close [
 state := #stopped
]

{ #category : #accessing }
GtLACPTransport >> connection [
 ^ connection
]

{ #category : #accessing }
GtLACPTransport >> connection: anObject [
 connection := anObject
]

{ #category : #accessing }
GtLACPTransport >> initialize [
 super initialize.
 state := #stopped
]

{ #category : #io }
GtLACPTransport >> send: aDictionary [
 self subclassResponsibility
]

{ #category : #lifecycle }
GtLACPTransport >> start [
 self subclassResponsibility
]

{ #category : #accessing }
GtLACPTransport >> state [
 ^ state
]

{ #category : #accessing }
GtLACPTransport >> state: anObject [
 state := anObject
]
