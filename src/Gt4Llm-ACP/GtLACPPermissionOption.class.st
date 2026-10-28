"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPPermissionOption,
	#superclass : #GtLACPObject,
	#instVars : [
		'request',
		'data'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPPermissionOption >> data [
 ^ data
]

{ #category : #accessing }
GtLACPPermissionOption >> data: anObject [
 data := anObject
]

{ #category : #views }
GtLACPPermissionOption >> gtChoiceFor: aView [
 <gtView>
 ^ aView columnedList title: 'Choice'; priority: 0;
  items: [ { 'Label' -> self name. 'Kind' -> self kind. 'Option ID' -> self id } ];
  column: 'Permission choice' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value
]

{ #category : #actions }
GtLACPPermissionOption >> gtSelectFor: anAction [
 <gtAction>
 request state = #pending ifFalse: [ ^ anAction noAction ].
 ^ anAction button label: self name; priority: 1; action: [ self select ]
]

{ #category : #accessing }
GtLACPPermissionOption >> id [
 ^ data at: 'optionId'
]

{ #category : #accessing }
GtLACPPermissionOption >> kind [
 ^ data at: 'kind'
]

{ #category : #accessing }
GtLACPPermissionOption >> name [
 ^ data at: 'name'
]

{ #category : #accessing }
GtLACPPermissionOption >> request [
 ^ request
]

{ #category : #accessing }
GtLACPPermissionOption >> request: anObject [
 request := anObject
]

{ #category : #permissions }
GtLACPPermissionOption >> select [
 request resolve: self id
]
