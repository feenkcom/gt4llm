"
I retain the file, storage format and selected native metadata used to discover a session. My Metadata view explains the evidence without loading conversation bodies into the discovery model.
"
Class {
	#name : #GtLACPStoredSessionSource,
	#superclass : #GtLACPObject,
	#instVars : [
		'file',
		'format',
		'metadata'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPStoredSessionSource >> file [
 ^ file
]

{ #category : #accessing }
GtLACPStoredSessionSource >> file: anObject [
 file := anObject
]

{ #category : #accessing }
GtLACPStoredSessionSource >> format [
 ^ format
]

{ #category : #accessing }
GtLACPStoredSessionSource >> format: anObject [
 format := anObject
]

{ #category : #views }
GtLACPStoredSessionSource >> gtMetadataFor: aView [
 <gtView>
 ^ aView columnedList title: 'Metadata'; priority: 0;
  items: [ metadata associations sorted: [ :a :b | a key <= b key ] ];
  column: 'Field' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value
]

{ #category : #accessing }
GtLACPStoredSessionSource >> metadata [
 ^ metadata
]

{ #category : #accessing }
GtLACPStoredSessionSource >> metadata: anObject [
 metadata := anObject
]

{ #category : #printing }
GtLACPStoredSessionSource >> printOn: aStream [
 aStream nextPutAll: format asString; nextPutAll: ': '; nextPutAll: file fullName
]
