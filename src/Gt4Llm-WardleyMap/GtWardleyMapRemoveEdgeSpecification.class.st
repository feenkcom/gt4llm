Class {
	#name : #GtWardleyMapRemoveEdgeSpecification,
	#superclass : #GtWardleyMapEdgeChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapRemoveEdgeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapRemoveEdge'
]

{ #category : #changes }
GtWardleyMapRemoveEdgeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapRemoveEdgeChange onMap: aWardleyMapModel)
		fromNodeId: fromNodeId;
		toNodeId: toNodeId;
		yourself
]

{ #category : #changes }
GtWardleyMapRemoveEdgeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	proposition := GtWardleyMapRemoveProposition new.
	change edge addWardleyMapDecoratorModel: proposition
]
