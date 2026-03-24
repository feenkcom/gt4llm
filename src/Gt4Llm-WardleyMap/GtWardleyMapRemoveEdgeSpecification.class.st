Class {
	#name : #GtWardleyMapRemoveEdgeSpecification,
	#superclass : #GtWardleyMapEdgeChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapRemoveEdgeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapRemoveEdge'
]

{ #category : #'as yet unclassified' }
GtWardleyMapRemoveEdgeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapRemoveEdgeChange onMap: aWardleyMapModel)
		edge: (self
				edgeFrom: fromNodeId
				to: toNodeId
				in: aWardleyMapModel);
		yourself
]

{ #category : #'as yet unclassified' }
GtWardleyMapRemoveEdgeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	proposition := GtWardleyMapRemoveProposition new.
	change edge addWardleyMapDecoratorModel: proposition
]
