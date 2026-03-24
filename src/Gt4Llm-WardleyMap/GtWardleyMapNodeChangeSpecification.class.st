Class {
	#name : #GtWardleyMapNodeChangeSpecification,
	#superclass : #GtWardleyMapChangeSpecification,
	#instVars : [
		'nodeId'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #accessing }
GtWardleyMapNodeChangeSpecification >> nodeId [
	^ nodeId
]

{ #category : #accessing }
GtWardleyMapNodeChangeSpecification >> nodeId: anObject [
	nodeId := anObject
]

{ #category : #accessing }
GtWardleyMapNodeChangeSpecification >> nodeIdDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #nodeId;
		  withUUIDFormatCommentWith: 'The id of the node'
]
