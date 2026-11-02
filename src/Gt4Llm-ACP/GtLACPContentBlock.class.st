"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPContentBlock,
	#superclass : #GtLACPObject,
	#instVars : [
		'data'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'instance creation' }
GtLACPContentBlock class >> text: aString [
 ^ self new data: { 'type' -> 'text'. 'text' -> aString } asDictionary; yourself
]

{ #category : #serialization }
GtLACPContentBlock >> asDictionary [
 ^ data
]

{ #category : #accessing }
GtLACPContentBlock >> data [
 ^ data
]

{ #category : #accessing }
GtLACPContentBlock >> data: anObject [
 data := anObject
]

{ #category : #views }
GtLACPContentBlock >> gtContentFor: aView [
 <gtView>
 ^ aView textEditor title: 'Content'; priority: 20; text: [ STONJSON toStringPretty: data ]; actionUpdateButtonTooltip: 'Refresh content'
]

{ #category : #accessing }
GtLACPContentBlock >> text [
 ^ data at: 'text' ifAbsent: [ '[', self type, ']' ]
]

{ #category : #accessing }
GtLACPContentBlock >> type [
 ^ data at: 'type'
]
