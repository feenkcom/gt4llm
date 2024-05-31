Class {
	#name : #GtWardleyPropositionModel,
	#superclass : #Object,
	#instVars : [
		'state',
		'proposition'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtWardleyPropositionModel >> change [
	^ GtWardleyMapModel new
		nodes: self nodeDifferences;
		edges: self edgeDifferences
]

{ #category : #accessing }
GtWardleyPropositionModel >> edgeDifferences [
	| stateEdges propositionEdges resultEdges |
	stateEdges := self state edges collect: #asDifferenceEdge.
	propositionEdges := self proposition edges collect: #asDifferenceEdge.
	resultEdges := OrderedCollection new.

	stateEdges
		do: [ :anEdge | 
			(propositionEdges includes: anEdge) ifFalse: [ anEdge markDeleted ].
			resultEdges add: anEdge ].

	propositionEdges
		do: [ :anEdge | 
			(stateEdges includes: anEdge)
				ifFalse: [ anEdge markAdded.
					resultEdges add: anEdge ] ].

	^ resultEdges
]

{ #category : #accessing }
GtWardleyPropositionModel >> gtChangeFor: aView [
	<gtView>
	^ aView forward
		title: 'Change';
		priority: 1;
		object: [ self change ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtWardleyPropositionModel >> gtPropositionFor: aView [
	<gtView>
	^ aView forward
		title: 'Proposition';
		priority: 3;
		object: [ self proposition ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtWardleyPropositionModel >> gtStateFor: aView [
	<gtView>
	^ aView forward
		title: 'State';
		priority: 2;
		object: [ self state ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtWardleyPropositionModel >> nodeDifferences [
	| stateNodes propositionNodes resultNodes |
	stateNodes := self state nodes collect: #asDifferenceNode.
	propositionNodes := self proposition nodes collect: #asDifferenceNode.
	resultNodes := OrderedCollection new.

	stateNodes
		do: [ :aNode | 
			(propositionNodes includes: aNode) ifFalse: [ aNode markDeleted ].
			resultNodes add: aNode ].

	propositionNodes
		do: [ :aNode | 
			(stateNodes includes: aNode)
				ifFalse: [ aNode markAdded.
					resultNodes add: aNode ] ].

	^ resultNodes
]

{ #category : #accessing }
GtWardleyPropositionModel >> proposition [
	^ proposition
]

{ #category : #accessing }
GtWardleyPropositionModel >> proposition: anObject [
	proposition := anObject
]

{ #category : #accessing }
GtWardleyPropositionModel >> state [
	^ state
]

{ #category : #accessing }
GtWardleyPropositionModel >> state: anObject [
	state := anObject
]
