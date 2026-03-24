Class {
	#name : #GtWardleyMapAddEdgeChangeSpecification,
	#superclass : #GtWardleyMapEdgePropertiesChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapAddEdgeChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapAddEdge'
]

{ #category : #changes }
GtWardleyMapAddEdgeChangeSpecification >> changeClass [
	^ GtWardleyMapAddEdgeChange
]

{ #category : #changes }
GtWardleyMapAddEdgeChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	change execute.
	proposition := GtWardleyMapAddProposition new.
	change newEdge addWardleyMapDecoratorModel: proposition
]
