Class {
	#name : #GtWardleyMapRemoveInnerNodeSpecification,
	#superclass : #GtWardleyMapChangeSpecification,
	#instVars : [
		'innerNodeId'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapRemoveInnerNodeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapRemoveInnerNode'
]

{ #category : #'as yet unclassified' }
GtWardleyMapRemoveInnerNodeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapRemoveInnerNodeChange onMap: aWardleyMapModel)
		innerNode: (self nodeWithId: innerNodeId in: aWardleyMapModel);
		yourself
]

{ #category : #accessing }
GtWardleyMapRemoveInnerNodeSpecification >> innerNodeId [
	^ innerNodeId
]

{ #category : #accessing }
GtWardleyMapRemoveInnerNodeSpecification >> innerNodeId: anObject [
	innerNodeId := anObject
]

{ #category : #accessing }
GtWardleyMapRemoveInnerNodeSpecification >> innerNodeIdDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #innerNodeId;
		  comment: 'The id of the inner node'
]
