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

{ #category : #changes }
GtWardleyMapRemoveInnerNodeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapRemoveInnerNodeChange onMap: aWardleyMapModel)
		innerNodeId: innerNodeId;
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

{ #category : #private }
GtWardleyMapRemoveInnerNodeSpecification >> updateNewUidsUsing: aDictionary [
	super updateNewUidsUsing: aDictionary.
	aDictionary at: innerNodeId ifPresent: [ :id | innerNodeId := id ]
]
