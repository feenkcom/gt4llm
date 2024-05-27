Class {
	#name : #GtLlmWardleyMapCreator,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges',
		'topic'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapCreator >> addNode: aName [
	nodes at: aName put: {'name' -> aName} asDictionary
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> clearEdges [
	edges removeAll
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> clearNodes [
	nodes removeAll
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> connectNode: aName to: anotherName [
	edges
		add: {'from' -> aName.
				'to' -> anotherName} asDictionary
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> gtListNodesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Nodes list';
		priority: 3;
		items: [ nodes values ];
		column: 'Name' text: [ :aDict | aDict at: 'name' ];
		column: 'X'
			text: [ :aDict | aDict at: 'x' ]
			width: 50;
		column: 'Y'
			text: [ :aDict | aDict at: 'y' ]
			width: 50
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 2;
		stencil: [
			GtWardleyMapElement withDefaultSections
				wardleyMapViewModel: (GtWardleyMapViewModel new wardleyMapModel: self model);
				yourself ]
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> initialize [
	nodes := Dictionary new.
	edges := OrderedCollection new.
	topic := ''
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> model [
	| model createdNodes |
	model := GtWardleyMapModel new.
	createdNodes := Dictionary new.

	nodes
		do: [ :aNode | 
			| modelNode |
			modelNode := GtWardleyMapNodeModel new label: (aNode at: 'name').
			aNode
				at: 'x'
				ifPresent: [ modelNode
						x: (aNode at: 'x');
						y: (aNode at: 'y') ].
			model addNode: (createdNodes at: (aNode at: 'name') put: modelNode) ].

	edges
		do: [ :anEdge | 
			model
				addEdge: (GtWardleyMapEdgeModel new
						fromNode: (createdNodes at: (anEdge at: 'from'));
						toNode: (createdNodes at: (anEdge at: 'to'));
						width: 2) ].

	^ model
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> serialize [
	^ '```topic
' , self topic
		, '
```
```node
'
		, (Character linefeed join: (nodes collect: [ :aNode | STONJSON toString: aNode ]))
		, '
```
```connection
'
		, (Character linefeed
				join: (edges collect: [ :anEdge | STONJSON toString: anEdge ]))
		, '
```'
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> setNode: aName toX: aNumber andY: anotherNumber [
	(nodes at: aName)
		at: 'x' put: aNumber;
		at: 'y' put: anotherNumber
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> topic [
	^ topic
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> topic: anObject [
	topic := anObject
]
