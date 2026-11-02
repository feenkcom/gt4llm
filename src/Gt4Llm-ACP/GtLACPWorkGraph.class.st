"
I project an ACP conversation into chronological work events and stable agent lanes. I retain lightweight rows; the columned list creates graphical cells only for visible rows. A caller lane makes root replies and delegated replies explicit.
"
Class {
	#name : #GtLACPWorkGraph,
	#superclass : #GtLACPObject,
	#instVars : [
		'session',
		'lanes',
		'rows',
		'laneBySession',
		'rowByKey',
		'callerLane'
	],
	#category : #'Gt4Llm-ACP-Work graph'
}

{ #category : #building }
GtLACPWorkGraph >> addRowsFor: aSession to: events [
	| times |
	times := self toolTimesFor: aSession.
	aSession turns copy
		do: [ :turn | 
			| start final |
			start := self
					rowFor: turn
					kind: (aSession isSubagent ifTrue: [ #spawn ] ifFalse: [ #prompt ])
					turn: turn
					at: turn startedAt.
			start
				sourceLane: (self callerLaneFor: turn);
				targetLane: start lane.
			events add: start.
			turn toolCalls copy
				do: [ :tool | 
					| row |
					row := self
							rowFor: tool
							kind: #tool
							turn: turn
							at: (self
									toolTimeFor: tool
									in: turn
									times: times).
					row
						sourceLane: row lane;
						targetLane: row lane.
					events add: row ].
			final := turn finalMessage.
			final
				ifNotNil: [ | row |
					row := self
							rowFor: final
							kind: #reply
							turn: turn
							at: (self replyTimeFor: turn).
					row
						sourceLane: row lane;
						targetLane: (self callerLaneFor: turn).
					events add: row ]
				ifNil: [ turn finishedAt
						ifNotNil: [ :finished | 
							| row |
							row := self
									rowFor: turn
									kind: #stop
									turn: turn
									at: finished.
							row
								sourceLane: row lane;
								targetLane: row lane.
							events add: row ] ] ]
]

{ #category : #accessing }
GtLACPWorkGraph >> allSessions [
	| result pending |
	result := OrderedCollection new.
	pending := OrderedCollection with: session.
	[ pending notEmpty ]
		whileTrue: [ | current |
			current := pending removeFirst.
			result add: current.
			pending addAll: current childSessions copy ].
	^ result
]

{ #category : #converting }
GtLACPWorkGraph >> asElement [
	^ GtLACPWorkGraphElement new
		graph: self;
		yourself
]

{ #category : #accessing }
GtLACPWorkGraph >> callerLane [
	^ callerLane
]

{ #category : #accessing }
GtLACPWorkGraph >> callerLaneFor: aTurn [
	aTurn parentTurn ifNotNil: [ :parent | ^ self laneFor: parent session ].
	^ aTurn session isSubagent
		ifTrue: [ self laneFor: aTurn session parentSubagent parentSession ]
		ifFalse: [ callerLane ]
]

{ #category : #accessing }
GtLACPWorkGraph >> graphWidth [
	^ lanes size * 12 + 20 max: 80
]

{ #category : #views }
GtLACPWorkGraph >> gtEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Events';
		priority: 10;
		items: [ self refresh rows ];
		column: 'Time'
			text: [ :row | row timestamp asTime printString ]
			width: 120;
		column: 'Agent'
			text: [ :row | row lane label ]
			width: 150;
		column: 'Event'
			text: #kind
			width: 80;
		column: 'Details' text: #description;
		column: 'State'
			text: #state
			width: 100;
		send: #object
]

{ #category : #views }
GtLACPWorkGraph >> gtGraphFor: aView [
	<gtView>
	^ aView explicit
		title: 'Work graph';
		priority: 5;
		stencil: [ self asElement ];
		actionUpdateButtonTooltip: 'Refresh agent work graph'
]

{ #category : #views }
GtLACPWorkGraph >> gtLanesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Lanes';
		priority: 20;
		items: [ self refresh lanes ];
		column: 'Lane'
			text: #index
			width: 60;
		column: 'Agent' text: #label;
		column: 'First event'
			text: #firstRow
			width: 100;
		column: 'Last event'
			text: #lastRow
			width: 100;
		send: #object
]

{ #category : #initialization }
GtLACPWorkGraph >> initialize [
	super initialize.
	lanes := OrderedCollection new.
	rows := OrderedCollection new.
	laneBySession := IdentityDictionary new.
	rowByKey := Dictionary new
]

{ #category : #accessing }
GtLACPWorkGraph >> laneFor: aSession [
	^ laneBySession
		at: aSession
		ifAbsentPut: [ | lane |
			lane := GtLACPWorkGraphLane new
					object: aSession;
					index: lanes size;
					yourself.
			lanes add: lane.
			lane ]
]

{ #category : #accessing }
GtLACPWorkGraph >> lanes [
	^ lanes
]

{ #category : #updating }
GtLACPWorkGraph >> refresh [
	| sessions children events |
	self laneFor: session.
	children := (self allSessions
			reject: [ :each | each == session or: [ each turns isEmpty ] ])
			sorted: [ :a :b | a turns first startedAt < b turns first startedAt ].
	sessions := {session} , children.
	sessions do: [ :each | (self laneFor: each) label: each conversationTitle ].
	events := OrderedCollection new.
	sessions do: [ :each | self addRowsFor: each to: events ].
	rows := events
			sorted: [ :a :b | 
				a timestamp = b timestamp
					ifTrue: [ a sequence < b sequence ]
					ifFalse: [ a timestamp < b timestamp ] ].
	rows withIndexDo: [ :row :index | row index: index ].
	self updateLaneBounds.
	^ self
]

{ #category : #building }
GtLACPWorkGraph >> replyTimeFor: aTurn [
	aTurn finishedAt ifNotNil: [ :time | ^ time ].
	^ (aTurn session updates copy reversed
		detect: [ :event | 
			event kind = 'agent_message_chunk'
				and: [ event timestamp >= aTurn startedAt
						and: [ aTurn finalMessage messageId isNil
								or: [ (event data at: 'messageId' ifAbsent: [ nil ]) = aTurn finalMessage messageId ] ] ] ]
		ifNone: [ ^ aTurn startedAt ]) timestamp
]

{ #category : #building }
GtLACPWorkGraph >> rowFor: anObject kind: aKind turn: aTurn at: aTimestamp [
	^ (rowByKey
		at: {aKind.
				anObject}
		ifAbsentPut: [ GtLACPWorkGraphRow new
				graph: self;
				object: anObject;
				kind: aKind;
				sequence: rowByKey size + 1;
				yourself ])
		turn: aTurn;
		timestamp: aTimestamp;
		lane: (self laneFor: aTurn session);
		yourself
]

{ #category : #accessing }
GtLACPWorkGraph >> rows [
	^ rows
]

{ #category : #accessing }
GtLACPWorkGraph >> session [
	^ session
]

{ #category : #accessing }
GtLACPWorkGraph >> session: aSession [
	session := aSession rootSession.
	callerLane := GtLACPWorkGraphLane new
			object: session client;
			label: 'You';
			index: 0;
			yourself.
	lanes add: callerLane
]

{ #category : #building }
GtLACPWorkGraph >> toolTimeFor: aTool in: aTurn times: times [
	^ (times at: aTool id ifAbsent: [ #() ])
		detect: [ :timestamp | 
			timestamp >= aTurn startedAt
				and: [ aTurn finishedAt isNil or: [ timestamp <= aTurn finishedAt ] ] ]
		ifNone: [ aTurn startedAt ]
]

{ #category : #building }
GtLACPWorkGraph >> toolTimesFor: aSession [
	| times |
	times := Dictionary new.
	aSession updates copy
		do: [ :update | 
			(#('tool_call' 'tool_call_update') includes: update kind)
				ifTrue: [ (times
						at: (update data at: 'toolCallId')
						ifAbsentPut: [ OrderedCollection new ]) add: update timestamp ] ].
	^ times
]

{ #category : #updating }
GtLACPWorkGraph >> updateLaneBounds [
	lanes
		do: [ :lane | 
			lane
				firstRow: rows size + 1;
				lastRow: 0 ].
	rows
		do: [ :row | 
			{row lane.
				row sourceLane.
				row targetLane}
				do: [ :lane | 
					lane
						firstRow: (lane firstRow min: row index);
						lastRow: (lane lastRow max: row index) ] ].
	laneBySession
		keysAndValuesDo: [ :each :lane | 
			(each currentTurn notNil and: [ each currentTurn isActive ])
				ifTrue: [ lane lastRow: rows size ] ]
]
