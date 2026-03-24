Class {
	#name : #GtWardleyMapUpdateEdgeChangeSpecification,
	#superclass : #GtWardleyMapEdgePropertiesChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapUpdateEdgeChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapUpdateEdge'
]

{ #category : #changes }
GtWardleyMapUpdateEdgeChangeSpecification >> changeClass [
	^ GtWardleyMapUpdateEdgeChange
]
