"
I draw one fixed-height slice of an agent work graph. Adjacent virtualized rows join their lane segments without requiring a single large canvas.
"
Class {
	#name : #GtLACPWorkGraphRowElement,
	#superclass : #BlElement,
	#instVars : [
		'row'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPWorkGraphRowElement >> addLineFrom: aPoint to: anotherPoint color: aColor [
	aPoint = anotherPoint ifTrue: [ ^ self ].
	self
		addChild: ((BlLineGeometry from: aPoint to: anotherPoint) asElement
				border: (BlBorder paint: aColor width: 2);
				yourself)
]

{ #category : #building }
GtLACPWorkGraphRowElement >> build [
	self removeChildren.
	self
		id: ('acp-work-graph-row-' , row index asString) asSymbol;
		size: row graph graphWidth @ 32;
		layout: BlBasicLayout new.
	row visibleLanes
		do: [ :lane | 
			self
				addLineFrom: lane x
						@ (lane firstRow = row index ifTrue: [ self yForLane: lane ] ifFalse: [ 0 ])
				to: lane x
						@ (lane lastRow = row index ifTrue: [ self yForLane: lane ] ifFalse: [ 32 ])
				color: lane color ].
	row sourceLane ~~ row targetLane ifTrue: [ self buildConnection ].
	self buildMarker
]

{ #category : #building }
GtLACPWorkGraphRowElement >> buildConnection [
	self
		addChild: (BlManhattanLineElement new
				id: #'acp-work-graph-connection';
				border: (BlBorder paint: row lane color width: 2);
				cornerRadius: 5;
				beVertical;
				proportion: 0.5;
				fromAnchor: (BlAbsolutePositionAnchor
						position: row sourceLane x @ (self yForLane: row sourceLane));
				toAnchor: (BlAbsolutePositionAnchor
						position: row targetLane x @ (self yForLane: row targetLane));
				yourself)
]

{ #category : #building }
GtLACPWorkGraphRowElement >> buildMarker [
	row kind = #tool ifFalse: [ ^ self ].
	self
		addChild: (BlElement new
				id: #'acp-work-graph-marker';
				size: 8 @ 8;
				position: (row lane x - 4) @ 12;
				geometry: BlCircleGeometry new;
				background: row lane color;
				border: (BlBorder paint: row lane color width: 2);
				yourself)
]

{ #category : #accessing }
GtLACPWorkGraphRowElement >> row [
	^ row
]

{ #category : #accessing }
GtLACPWorkGraphRowElement >> row: aRow [
	row := aRow
]

{ #category : #building }
GtLACPWorkGraphRowElement >> yForLane: aLane [
	row sourceLane == row targetLane ifTrue: [ ^ 16 ].
	aLane == row sourceLane ifTrue: [ ^ 8 ].
	aLane == row targetLane ifTrue: [ ^ 24 ].
	^ 16
]
