Class {
	#name : #GtWardleyMapUpdateNoteChangeSpecification,
	#superclass : #GtWardleyMapNotePropertiesChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapUpdateNoteChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapUpdateNote'
]

{ #category : #changes }
GtWardleyMapUpdateNoteChangeSpecification >> changeClass [
	^ GtWardleyMapUpdateNoteChange
]
