Class {
	#name : #GtLlmWardleyMapCreator,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'model'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapCreator >> addNode: aName [
	| aNode |
	aNode := GtWardleyMapNodeModel new label: aName.
	nodes at: aName put: aNode.
	model addNode: aNode
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> clearEdges [
	model edges: {}
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> clearNodes [
	nodes removeAll.
	model nodes: {}
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> connectNode: aName to: anotherName [
	
	model
		addEdge: (GtWardleyMapEdgeModel new
				fromNode: (self ensurePropositionNodeNamed:  aName);
				toNode: (self ensurePropositionNodeNamed:  anotherName);
				width: 2)
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> ensurePropositionNodeNamed: aName [
	| newNodeModel |
	
	nodes at: aName ifPresent: [:aNode | ^ aNode ].
	
	newNodeModel := GtWardleyMapNodeModel new
		label: aName;
		addWardleyMapDecoratorModel: GtWardleyMapAddProposition new.
		
	self model addNode: newNodeModel.
	nodes at: aName put: newNodeModel.
	
	^ newNodeModel
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> gtListNodesFor: aView [
	<gtView>
	^ aView forward
		title: 'Nodes';
		priority: 3;
		object: [ self model ];
		view: #gtNodesFor:
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
	model := GtWardleyMapModel new.
	nodes := Dictionary new
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> model [
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
		, (Character linefeed
				join: (self model nodes
						collect: [ :aNode | 
							STONJSON
								toString: {'name' -> aNode label.
										'x' -> aNode x.
										'y' -> aNode y} asDictionary ]))
		, '
```
```connection
'
		, (Character linefeed
				join: (self model edges
						collect: [ :anEdge | 
							STONJSON
								toString: {'from' -> anEdge fromNode label.
										'to' -> anEdge toNode label} asDictionary ]))
		, '
```'
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> setNode: aName toX: aNumber andY: anotherNumber [
	(nodes at: aName)
		x: aNumber;
		y: anotherNumber
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> topic [
	^ self model title
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> topic: anObject [
	self model title: anObject
]
