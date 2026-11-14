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
	^ aView columnedList
		title: 'Sessions';
		priority: 0;
		items: aBlock;
		column: 'Agent'
			text: #agentName
			width: 95;
		column: 'Title' text: #title;
		column: 'Project directory'
			text: [ :each | 
				each directory
					ifNil: [ '(unknown)' ]
					ifNotNil: [ :aDirectory | aDirectory fullName ] ];
		column: 'Session ID' text: #sessionId;
		column: 'Metadata time'
			text: [ :each | 
				(each updatedAt ifNil: [ each createdAt ])
					ifNil: [ '(unknown)' ]
					ifNotNil: [ :aTime | aTime asString ] ];
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

{ #category : #'gt - extensions' }
GtLACPStoredSession >> gtDetailsFor: aView [
	"Which identity and project metadata describe this stored session?"

	<gtView>
	| valueText |
	valueText := [ :value | value ifNil: [ '(unknown)' ] ifNotNil: [ :aValue | aValue asString ] ].
	^ aView details
		title: 'Details';
		priority: 5;
		row: 'Agent'
			value: [ self agentName ]
			text: valueText;
		row: 'Session ID'
			value: [ sessionId ]
			text: valueText;
		row: 'Project directory'
			value: [ directory ]
			text: valueText;
		row: 'Title'
			value: [ title ]
			text: valueText;
		row: 'Created'
			value: [ createdAt ]
			text: valueText;
		row: 'Updated'
			value: [ updatedAt ]
			text: valueText
]

{ #category : #'gt - actions' }
GtLACPStoredSession >> gtLoadFor: anAction [
	<gtAction>
	^ anAction button
		id: #'acp-load-stored-session';
		label: 'Load session';
		icon: BrGlamorousVectorIcons play;
		priority: 10;
		action: [ :anElement | 
			| session |
			session := self load.
			anElement phlow spawnObject: session ]
]

{ #category : #views }
GtLACPStoredSession >> gtSourcesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Sources';
		priority: 0;
		items: [ sources ];
		column: 'Format'
			text: #format
			width: 130;
		column: 'File' text: [ :source | source file fullName ]
]

{ #category : #initialization }
GtLACPStoredSession >> initialize [
 super initialize.
 sources := OrderedCollection new.
 title := ''
]

{ #category : #loading }
GtLACPStoredSession >> load [
	^ self loadConfigureClient: [ :client |  ]
]

{ #category : #loading }
GtLACPStoredSession >> loadConfigureClient: aBlock [
	| client |
	directory
		ifNil: [ self
				error: 'Session found, but its project directory is unknown: ' , sessionId asString ].
	directory isDirectory
		ifFalse: [ self
				error: 'The recorded project directory no longer exists: ' , directory fullName ].
	client := self newClient.
	aBlock value: client.
	^ client loadSession: sessionId in: directory
]

{ #category : #loading }
GtLACPStoredSession >> newClient [
	^ self subclassResponsibility
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
