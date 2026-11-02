"
I query a store for an exact project directory. Matches and Unknown directory views distinguish confirmed matches from conversations whose metadata is insufficient to decide.
"
Class {
	#name : #GtLACPStoredSessionQuery,
	#superclass : #GtLACPObject,
	#instVars : [
		'store',
		'directory'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPStoredSessionQuery >> directory [
 ^ directory
]

{ #category : #accessing }
GtLACPStoredSessionQuery >> directory: anObject [
 directory := anObject
]

{ #category : #views }
GtLACPStoredSessionQuery >> gtIssuesFor: aView [
 <gtView>
 ^ aView forward title: 'Read problems'; priority: 10; object: [ store ]; view: #gtIssuesFor:
]

{ #category : #views }
GtLACPStoredSessionQuery >> gtSessionsFor: aView [
 <gtView>
 ^ (GtLACPStoredSession sessionsView: aView items: [ self sessions ]) title: 'Matches'
]

{ #category : #views }
GtLACPStoredSessionQuery >> gtUnresolvedFor: aView [
 <gtView>
 ^ (GtLACPStoredSession sessionsView: aView items: [ self unresolvedSessions ])
  title: 'Unknown directory'; priority: 5
]

{ #category : #printing }
GtLACPStoredSessionQuery >> printOn: aStream [
 aStream nextPutAll: store agentName; nextPutAll: ' sessions in '; nextPutAll: directory fullName
]

{ #category : #querying }
GtLACPStoredSessionQuery >> sessions [
 ^ store sessions select: [ :session | session directory = directory ]
]

{ #category : #accessing }
GtLACPStoredSessionQuery >> store [
 ^ store
]

{ #category : #accessing }
GtLACPStoredSessionQuery >> store: anObject [
 store := anObject
]

{ #category : #querying }
GtLACPStoredSessionQuery >> unresolvedSessions [
 ^ store sessions select: [ :session | session directory isNil ]
]
