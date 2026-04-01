Class {
	#name : #GtWardleyMapEdgeChangeSpecification,
	#superclass : #GtWardleyMapChangeSpecification,
	#instVars : [
		'fromNodeId',
		'toNodeId'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #accessing }
GtWardleyMapEdgeChangeSpecification >> fromNodeId [
	^ fromNodeId
]

{ #category : #accessing }
GtWardleyMapEdgeChangeSpecification >> fromNodeId: anObject [
	fromNodeId := anObject
]

{ #category : #accessing }
GtWardleyMapEdgeChangeSpecification >> fromNodeIdDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #fromNodeId;
		  withUUIDFormatCommentWith: 'The id of the from node for the edge'
]

{ #category : #accessing }
GtWardleyMapEdgeChangeSpecification >> toNodeId [
	^ toNodeId
]

{ #category : #accessing }
GtWardleyMapEdgeChangeSpecification >> toNodeId: anObject [
	toNodeId := anObject
]

{ #category : #accessing }
GtWardleyMapEdgeChangeSpecification >> toNodeIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #toNodeId;
		withUUIDFormatCommentWith: 'The id of the to node for the edge'
]

{ #category : #private }
GtWardleyMapEdgeChangeSpecification >> updateNewUidsUsing: aDictionary [
	super updateNewUidsUsing: aDictionary.
	aDictionary at: fromNodeId ifPresent: [ :id | fromNodeId := id ].
	aDictionary at: toNodeId ifPresent: [ :id | toNodeId := id ]
]
