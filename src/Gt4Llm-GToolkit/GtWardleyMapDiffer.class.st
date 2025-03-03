Class {
	#name : #GtWardleyMapDiffer,
	#superclass : #Object,
	#instVars : [
		'from',
		'to'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtWardleyMapDiffer class >> diffFrom: aModel to: anotherModel [
	^ self new
		from: aModel;
		to: anotherModel
]

{ #category : #accessing }
GtWardleyMapDiffer >> addedEdges [
	| fromEdgePairs |
	fromEdgePairs := self from edges
			collect: [ :anEdge | anEdge fromNode label -> anEdge toNode label ].
	^ self to edges
		reject: [ :anEdge | fromEdgePairs includes: anEdge fromNode label -> anEdge toNode label ]
]

{ #category : #accessing }
GtWardleyMapDiffer >> addedNodes [
	| fromNodeNames |
	fromNodeNames := self from nodes collect: #label.
	^ self to nodes reject: [ :aNode | fromNodeNames includes: aNode label ]
]

{ #category : #accessing }
GtWardleyMapDiffer >> from [
	^ from
]

{ #category : #accessing }
GtWardleyMapDiffer >> from: anObject [
	from := anObject
]

{ #category : #'as yet unclassified' }
GtWardleyMapDiffer >> merge [
	self addedNodes
		do: [ :aNode | 
			from
				addNode: (aNode removeParent addWardleyMapDecoratorModel: GtWardleyMapAddProposition new) ].
	self addedEdges
		do: [ :anEdge | 
			from
				addEdge: (anEdge removeParent addWardleyMapDecoratorModel: GtWardleyMapAddProposition new) ].

	self removedEdges
		do: [ :anEdge | anEdge addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ].
	self removedNodes
		do: [ :aNode | aNode addWardleyMapDecoratorModel: GtWardleyMapRemoveProposition new ].
		
	from ensureAllProposition
]

{ #category : #accessing }
GtWardleyMapDiffer >> removedEdges [
	| toEdgePairs |
	toEdgePairs := self to edges
			collect: [ :anEdge | anEdge fromNode label -> anEdge toNode label ].
	^ self from edges
		reject: [ :anEdge | toEdgePairs includes: anEdge fromNode label -> anEdge toNode label ]
]

{ #category : #accessing }
GtWardleyMapDiffer >> removedNodes [
	| toNodeNames |
	toNodeNames := self to nodes collect: #label.
	^ self from nodes reject: [ :aNode | toNodeNames includes: aNode label ]
]

{ #category : #accessing }
GtWardleyMapDiffer >> to [
	^ to
]

{ #category : #accessing }
GtWardleyMapDiffer >> to: anObject [
	to := anObject
]
