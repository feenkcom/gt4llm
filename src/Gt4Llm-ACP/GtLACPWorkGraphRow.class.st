"
I describe one prompt, agent start, tool call, reply or stopped turn. My source and target lanes describe delegation and return edges. I expose the underlying ACP object for inspection.
"
Class {
	#name : #GtLACPWorkGraphRow,
	#superclass : #GtLACPObject,
	#instVars : [
		'graph',
		'object',
		'turn',
		'kind',
		'timestamp',
		'lane',
		'sourceLane',
		'targetLane',
		'index',
		'sequence'
	],
	#category : #'Gt4Llm-ACP-Work graph'
}

{ #category : #converting }
GtLACPWorkGraphRow >> asGraphElement [
	^ GtLACPWorkGraphRowElement new
		row: self;
		build;
		yourself
]

{ #category : #accessing }
GtLACPWorkGraphRow >> description [
	kind = #tool ifTrue: [ ^ object summary ].
	kind = #spawn ifTrue: [ ^ 'Started by ' , sourceLane label ].
	kind = #reply ifTrue: [ ^ object text trimBoth firstLineWithEllipsis ].
	kind = #stop
		ifTrue: [ ^ turn error ifNil: [ turn state asString ] ifNotNil: #asString ].
	^ turn inputMessages
		ifEmpty: [ 'Observed conversation' ]
		ifNotEmpty: [ :messages | messages first text trimBoth firstLineWithEllipsis ]
]

{ #category : #accessing }
GtLACPWorkGraphRow >> graph [
	^ graph
]

{ #category : #accessing }
GtLACPWorkGraphRow >> graph: aValue [
	graph := aValue
]

{ #category : #views }
GtLACPWorkGraphRow >> gtEventFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Event';
		priority: 0;
		items: [ {'Kind' -> kind.
				'Time' -> timestamp.
				'Agent' -> lane label.
				'From' -> sourceLane label.
				'To' -> targetLane label.
				'Object' -> object.
				'Turn' -> turn} ];
		column: 'Property'
			text: #key
			width: 100;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLACPWorkGraphRow >> index [
	^ index
]

{ #category : #accessing }
GtLACPWorkGraphRow >> index: aValue [
	index := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> kind [
	^ kind
]

{ #category : #accessing }
GtLACPWorkGraphRow >> kind: aValue [
	kind := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> lane [
	^ lane
]

{ #category : #accessing }
GtLACPWorkGraphRow >> lane: aValue [
	lane := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> object [
	^ object
]

{ #category : #accessing }
GtLACPWorkGraphRow >> object: aValue [
	object := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> renderingKey [
	^ {kind.
		self description.
		self state.
		lane label.
		timestamp.
		graph graphWidth.
		sourceLane index.
		targetLane index.
		self visibleLanes
			collect: [ :each | 
				{each index.
					each firstRow = index.
					each lastRow = index} ]}
]

{ #category : #accessing }
GtLACPWorkGraphRow >> sequence [
	^ sequence
]

{ #category : #accessing }
GtLACPWorkGraphRow >> sequence: aValue [
	sequence := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> sourceLane [
	^ sourceLane
]

{ #category : #accessing }
GtLACPWorkGraphRow >> sourceLane: aValue [
	sourceLane := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> state [
	^ kind = #tool ifTrue: [ object status ] ifFalse: [ turn state asString ]
]

{ #category : #accessing }
GtLACPWorkGraphRow >> targetLane [
	^ targetLane
]

{ #category : #accessing }
GtLACPWorkGraphRow >> targetLane: aValue [
	targetLane := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> timestamp [
	^ timestamp
]

{ #category : #accessing }
GtLACPWorkGraphRow >> timestamp: aValue [
	timestamp := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> turn [
	^ turn
]

{ #category : #accessing }
GtLACPWorkGraphRow >> turn: aValue [
	turn := aValue
]

{ #category : #accessing }
GtLACPWorkGraphRow >> visibleLanes [
	^ graph lanes select: [ :each | each coversRow: index ]
]
