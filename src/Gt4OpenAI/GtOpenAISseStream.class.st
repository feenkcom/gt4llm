Class {
	#name : #GtOpenAISseStream,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'stream',
		'events',
		'announcer',
		'consumeFuture'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> addEvent: anEvent [
	events add: anEvent.

	self announce: (GtOpenAISseEventAdded new event: anEvent)
]

{ #category : #announcer }
GtOpenAISseStream >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> consumeFuture [
	^ GtOpenAISseConsumerFuture new stream: self
]

{ #category : #accessing }
GtOpenAISseStream >> events [
	^ events
]

{ #category : #accessing }
GtOpenAISseStream >> events: anObject [
	events := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> eventsOfType: anEventType [
	^ self events select: [ :anEvent | anEvent eventType = anEventType ]
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> gtEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Events';
		priority: 1;
		items: [ self events ];
		updateWhen: GtOpenAISseEventAdded in: self announcer;
		column: 'Type'
			text: #eventType
			width: 100;
		column: 'Data' text: #data
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> gtSseFor: aView [
	<gtView>
	^ aView textEditor
		title: 'SSE';
		priority: 5;
		text: [ self toSseString ]
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> hasEventOfType: anEventType [
	^ self events anySatisfy: [ :anEvent | anEvent eventType = anEventType ]
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> initialize [
	super initialize.
	events := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> isAtEnd [
	^ self events isNotEmpty
		and: [ self events last eventType = 'response.completed' ]
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> isReadyForMore [
	^ self stream peek isNotNil
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> nextData [
	| data linefeedInt |
	data := ''.
	linefeedInt := Character linefeed asInteger.
	[ data := data
			, (data
					ifEmpty: [ '' ]
					ifNotEmpty: [ '
' ]) , (self stream upTo: linefeedInt) utf8Decoded ]
		doWhileFalse: [ self stream peek isNil or: [ self stream peek = linefeedInt ] ].

	self stream next.

	^ data
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> nextEvent [
	^ GtOpenAISseEvent fromString: self nextData
]

{ #category : #accessing }
GtOpenAISseStream >> stream [
	^ stream
]

{ #category : #accessing }
GtOpenAISseStream >> stream: anObject [
	stream := anObject.
	
	consumeFuture := self consumeFuture await
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> toSseString [
	^ '

'
		join: (self events collect: [ :anEvent | anEvent toSseString ])
]

{ #category : #'as yet unclassified' }
GtOpenAISseStream >> waitForCompletion [
	self consumeFuture wait
]
