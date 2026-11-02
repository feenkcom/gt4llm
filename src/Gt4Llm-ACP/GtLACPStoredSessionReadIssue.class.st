"
I explain why an external session artifact could not provide metadata. My Details view identifies the file, record and reason instead of silently dropping discovery gaps.
"
Class {
	#name : #GtLACPStoredSessionReadIssue,
	#superclass : #GtLACPObject,
	#instVars : [
		'file',
		'lineNumber',
		'description'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPStoredSessionReadIssue >> description [
 ^ description
]

{ #category : #accessing }
GtLACPStoredSessionReadIssue >> description: anObject [
 description := anObject
]

{ #category : #accessing }
GtLACPStoredSessionReadIssue >> file [
 ^ file
]

{ #category : #accessing }
GtLACPStoredSessionReadIssue >> file: anObject [
 file := anObject
]

{ #category : #views }
GtLACPStoredSessionReadIssue >> gtDetailsFor: aView [
 <gtView>
 ^ aView columnedList title: 'Read problem'; priority: 0;
  items: [ { 'File' -> file. 'Line' -> lineNumber. 'Reason' -> description } ];
  column: 'Problem' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value
]

{ #category : #accessing }
GtLACPStoredSessionReadIssue >> lineNumber [
 ^ lineNumber
]

{ #category : #accessing }
GtLACPStoredSessionReadIssue >> lineNumber: anObject [
 lineNumber := anObject
]

{ #category : #printing }
GtLACPStoredSessionReadIssue >> printOn: aStream [
 aStream nextPutAll: description; nextPutAll: ' — '; nextPutAll: file fullName
]
