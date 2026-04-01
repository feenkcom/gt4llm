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
		edge: (self
				edgeFrom: fromNodeId
				to: toNodeId
				in: aWardleyMapModel);
		yourself
]

{ #category : #changes }
GtWardleyMapRemoveEdgeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	proposition := GtWardleyMapRemoveProposition new.
	change edge addWardleyMapDecoratorModel: proposition
]
