Class {
	#name : #GtWardleyMapEdgeDifferenceModel,
	#superclass : #GtWardleyMapEdgeModel,
	#instVars : [
		'isAdded',
		'isDeleted'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtWardleyMapEdgeDifferenceModel class >> from: anEdge [
	^ self new
		fromNode: anEdge fromNode asDifferenceNode;
		toNode: anEdge toNode asDifferenceNode;
		color: anEdge color;
		width: anEdge width;
		arrow: anEdge arrow;
		labelModel: anEdge labelModel
]

{ #category : #accessing }
GtWardleyMapEdgeDifferenceModel >> color [
	isAdded ifTrue: [ ^ BrGlamorousColors insertLineColor ].

	isDeleted ifTrue: [ ^ BrGlamorousColors removeLineColor ].

	^ color
]

{ #category : #accessing }
GtWardleyMapEdgeDifferenceModel >> initialize [
	super initialize.

	isAdded := false.
	isDeleted := false
]

{ #category : #accessing }
GtWardleyMapEdgeDifferenceModel >> markAdded [
	isAdded := true
]

{ #category : #accessing }
GtWardleyMapEdgeDifferenceModel >> markDeleted [
	isDeleted := true
]
