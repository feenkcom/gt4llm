"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPSessionUpdate,
	#superclass : #GtLACPObject,
	#instVars : [
		'data',
		'timestamp'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPSessionUpdate >> data [
 ^ data
]

{ #category : #accessing }
GtLACPSessionUpdate >> data: anObject [
 data := anObject
]

{ #category : #views }
GtLACPSessionUpdate >> gtUpdateFor: aView [
 <gtView>
 ^ aView textEditor title: 'Update'; priority: 20; text: [ STONJSON toStringPretty: data ]; actionUpdateButtonTooltip: 'Refresh update'
]

{ #category : #accessing }
GtLACPSessionUpdate >> kind [
 ^ data at: 'sessionUpdate'
]

{ #category : #accessing }
GtLACPSessionUpdate >> timestamp [
 ^ timestamp
]

{ #category : #accessing }
GtLACPSessionUpdate >> timestamp: anObject [
 timestamp := anObject
]
