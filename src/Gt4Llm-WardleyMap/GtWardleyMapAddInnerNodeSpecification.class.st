Class {
	#name : #GtWardleyMapAddInnerNodeSpecification,
	#superclass : #GtWardleyMapChangeSpecification,
	#instVars : [
		'innerNodeId',
		'outerNodeId'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapAddInnerNodeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapAddInnerNode'
]

{ #category : #changes }
GtWardleyMapAddInnerNodeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapAddInnerNodeChange onMap: aWardleyMapModel)
		innerNodeId: innerNodeId;
		outerNodeId: outerNodeId;
		yourself
]

{ #category : #accessing }
GtWardleyMapAddInnerNodeSpecification >> innerNodeId [
	^ innerNodeId
]

{ #category : #accessing }
GtWardleyMapAddInnerNodeSpecification >> innerNodeId: anObject [
	innerNodeId := anObject
]

{ #category : #accessing }
GtWardleyMapAddInnerNodeSpecification >> innerNodeIdDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #innerNodeId;
		  comment: 'The id of the inner node'
]

{ #category : #accessing }
GtWardleyMapAddInnerNodeSpecification >> outerNodeId [
	^ outerNodeId
]

{ #category : #accessing }
GtWardleyMapAddInnerNodeSpecification >> outerNodeId: anObject [
	outerNodeId := anObject
]

{ #category : #accessing }
GtWardleyMapAddInnerNodeSpecification >> outerNodeIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #outerNodeId;
		comment: 'The id of the outer node'
]

{ #category : #private }
GtWardleyMapAddInnerNodeSpecification >> updateNewUidsUsing: aDictionary [
	super updateNewUidsUsing: aDictionary.
	aDictionary at: innerNodeId ifPresent: [ :id | innerNodeId := id ].
	aDictionary at: outerNodeId ifPresent: [ :id | outerNodeId := id ]
]
