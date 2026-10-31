"
I describe one native conversation discovered on disk, distinct from a live ACP session. My Sources view preserves provenance. Missing directory metadata stays unknown; discovery does not imply that an adapter can resume me.
"
Class {
	#name : #GtLACPStoredSession,
	#superclass : #GtLACPObject,
	#instVars : [
		'store',
		'sessionId',
		'directory',
		'title',
		'createdAt',
		'updatedAt',
		'sources'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #views }
GtLACPStoredSession class >> sessionsView: aView items: aBlock [
 ^ aView columnedList title: 'Sessions'; priority: 0; items: aBlock;
  column: 'Agent' text: #agentName width: 95;
  column: 'Title' text: #title;
  column: 'Project directory' text: [ :each | each directory ifNil: [ '(unknown)' ] ifNotNil: #fullName ];
  column: 'Session ID' text: #sessionId;
  column: 'Metadata time' text: [ :each |
   (each updatedAt ifNil: [ each createdAt ]) ifNil: [ '(unknown)' ] ifNotNil: #asString ];
  actionUpdateButtonTooltip: 'Refresh session list'
]

{ #category : #reading }
GtLACPStoredSession >> addSource: aSource [
 sources add: aSource
]

{ #category : #accessing }
GtLACPStoredSession >> agentName [
 ^ store agentName
]

{ #category : #accessing }
GtLACPStoredSession >> createdAt [
 ^ createdAt
]

{ #category : #accessing }
GtLACPStoredSession >> createdAt: anObject [
 createdAt := anObject
]

{ #category : #accessing }
GtLACPStoredSession >> directory [
 ^ directory
]

{ #category : #accessing }
GtLACPStoredSession >> directory: anObject [
 directory := anObject
]

{ #category : #views }
GtLACPStoredSession >> gtIdentityFor: aView [
 <gtView>
 ^ aView columnedList title: 'Identity'; priority: 5;
  items: [ { 'Agent' -> self agentName. 'Session ID' -> sessionId.
   'Project directory' -> directory. 'Title' -> title.
   'Created' -> createdAt. 'Updated' -> updatedAt } ];
  column: 'Identity' text: #key;
  column: 'Value' text: [ :entry | entry value ifNil: [ '(unknown)' ] ifNotNil: #printString ];
  send: #value
]

{ #category : #views }
GtLACPStoredSession >> gtSourcesFor: aView [
 <gtView>
 ^ aView columnedList title: 'Sources'; priority: 0; items: [ sources ];
  column: 'Format' text: #format width: 130;
  column: 'File' text: [ :source | source file fullName ]
]

{ #category : #initialization }
GtLACPStoredSession >> initialize [
 super initialize.
 sources := OrderedCollection new.
 title := ''
]

{ #category : #printing }
GtLACPStoredSession >> printOn: aStream [
 aStream nextPutAll: self agentName; nextPutAll: ' session '; nextPutAll: sessionId.
 directory ifNotNil: [ aStream nextPutAll: ' in '; nextPutAll: directory fullName ]
]

{ #category : #accessing }
GtLACPStoredSession >> sessionId [
 ^ sessionId
]

{ #category : #accessing }
GtLACPStoredSession >> sessionId: anObject [
 sessionId := anObject
]

{ #category : #accessing }
GtLACPStoredSession >> sortKey [
 ^ updatedAt
  ifNil: [ createdAt ifNil: [ '' ] ifNotNil: [ :date | date asString ] ]
  ifNotNil: [ :date | date asString ]
]

{ #category : #accessing }
GtLACPStoredSession >> sources [
 ^ sources
]

{ #category : #accessing }
GtLACPStoredSession >> store [
 ^ store
]

{ #category : #accessing }
GtLACPStoredSession >> store: anObject [
 store := anObject
]

{ #category : #accessing }
GtLACPStoredSession >> title [
 ^ title
]

{ #category : #accessing }
GtLACPStoredSession >> title: anObject [
 title := anObject
]

{ #category : #accessing }
GtLACPStoredSession >> updatedAt [
 ^ updatedAt
]

{ #category : #accessing }
GtLACPStoredSession >> updatedAt: anObject [
 updatedAt := anObject
]
