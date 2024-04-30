Class {
	#name : #GtLlmWardleyMapCreator,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapCreator >> addNode: aName [
	nodes at: aName put: {'name' -> aName} asDictionary
]

{ #category : #accessing }
GtLlmWardleyMapCreator >> connectNode: aName to: anotherName [
	edges
		add: {'from' -> aName.
				'to' -> anotherName} asDictionary
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
	edges := OrderedCollection new
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
GtLlmWardleyMapCreator >> setNode: aName toX: aNumber andY: anotherNumber [
	(nodes at: aName)
		at: 'x' put: aNumber;
		at: 'y' put: anotherNumber
]
