Class {
	#name : #GtWardleyMapUpdateNodeChangeSpecification,
	#superclass : #GtWardleyMapNodePropertiesChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapUpdateNodeChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapUpdateNode'
]

{ #category : #changes }
GtWardleyMapUpdateNodeChangeSpecification >> changeClass [
	^ GtWardleyMapUpdateNodeChange
]
