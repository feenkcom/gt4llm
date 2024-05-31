Class {
	#name : #GtWardleyMapNodeDifferenceModel,
	#superclass : #GtWardleyMapNodeModel,
	#instVars : [
		'isAdded',
		'isDeleted'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtWardleyMapNodeDifferenceModel class >> from: aNode [
	| anInstance |
	anInstance := self new
			id: aNode id;
			color: aNode color;
			coordinate: aNode coordinate;
			isPipelineVisible: aNode isPipelineVisible;
			labelModel: aNode labelModel;
			pipelineCoordinate: aNode pipelineCoordinate;
			size: aNode size.

	aNode isPipelineVisible
		ifTrue: [ anInstance innerNodes: (aNode innerNodes collect: #asDifferenceNode) ].

	^ anInstance
]

{ #category : #accessing }
GtWardleyMapNodeDifferenceModel >> = anObject [
	"removes ID and color check from the parent class"
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self coordinate = anObject coordinate
				and: [ self innerNodes = anObject innerNodes
						and: [ self isPipelineVisible = anObject isPipelineVisible
								and: [ self labelModel = anObject labelModel
										and: [ self pipelineCoordinate = anObject pipelineCoordinate
												and: [ self size = anObject size ] ] ] ] ]
]

{ #category : #accessing }
GtWardleyMapNodeDifferenceModel >> color [
	isAdded ifTrue: [ ^ BrGlamorousColors insertLineColor ].

	isDeleted ifTrue: [ ^ BrGlamorousColors removeLineColor ].

	^ color
]

{ #category : #accessing }
GtWardleyMapNodeDifferenceModel >> hash [
	^ self color hash
		bitXor: (self coordinate hash
				bitXor: (self innerNodes hash
						bitXor: (self isPipelineVisible hash
								bitXor: (self labelModel hash
										bitXor: (self pipelineCoordinate hash bitXor: self size hash)))))
]

{ #category : #accessing }
GtWardleyMapNodeDifferenceModel >> initialize [
	super initialize.

	isAdded := false.
	isDeleted := false
]

{ #category : #accessing }
GtWardleyMapNodeDifferenceModel >> markAdded [
	isAdded := true
]

{ #category : #accessing }
GtWardleyMapNodeDifferenceModel >> markDeleted [
	isDeleted := true
]
