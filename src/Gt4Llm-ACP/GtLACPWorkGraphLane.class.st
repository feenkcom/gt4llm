"
I give one agent, or its caller, a stable vertical lane and color in a work graph. My bounds describe where my line starts and ends.
"
Class {
	#name : #GtLACPWorkGraphLane,
	#superclass : #GtLACPObject,
	#instVars : [
		'object',
		'label',
		'index',
		'firstRow',
		'lastRow'
	],
	#category : #'Gt4Llm-ACP-Work graph'
}

{ #category : #accessing }
GtLACPWorkGraphLane >> color [
	^ index isZero
		ifTrue: [ Color gray ]
		ifFalse: [ Color
				h: index * 137.5 \\ 360
				s: 0.65
				v: 0.75 ]
]

{ #category : #accessing }
GtLACPWorkGraphLane >> coversRow: anIndex [
	^ firstRow <= anIndex and: [ anIndex <= lastRow ]
]

{ #category : #accessing }
GtLACPWorkGraphLane >> firstRow [
	^ firstRow
]

{ #category : #accessing }
GtLACPWorkGraphLane >> firstRow: aValue [
	firstRow := aValue
]

{ #category : #views }
GtLACPWorkGraphLane >> gtSpanFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Span';
		priority: 0;
		items: [ {'Agent' -> label.
				'Lane' -> index.
				'First event' -> firstRow.
				'Last event' -> lastRow.
				'Object' -> object} ];
		column: 'Property'
			text: #key
			width: 100;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLACPWorkGraphLane >> index [
	^ index
]

{ #category : #accessing }
GtLACPWorkGraphLane >> index: aValue [
	index := aValue
]

{ #category : #accessing }
GtLACPWorkGraphLane >> label [
	^ label
]

{ #category : #accessing }
GtLACPWorkGraphLane >> label: aValue [
	label := aValue
]

{ #category : #accessing }
GtLACPWorkGraphLane >> lastRow [
	^ lastRow
]

{ #category : #accessing }
GtLACPWorkGraphLane >> lastRow: aValue [
	lastRow := aValue
]

{ #category : #accessing }
GtLACPWorkGraphLane >> object [
	^ object
]

{ #category : #accessing }
GtLACPWorkGraphLane >> object: aValue [
	object := aValue
]

{ #category : #accessing }
GtLACPWorkGraphLane >> x [
	^ 16 + (index * 12)
]
