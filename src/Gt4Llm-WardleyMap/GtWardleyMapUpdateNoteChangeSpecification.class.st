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
GtWardleyMapUpdateNoteChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (super asChangeIn: aWardleyMapModel)
		note: (self noteWithId: noteId in: aWardleyMapModel);
		yourself
]

{ #category : #changes }
GtWardleyMapUpdateNoteChangeSpecification >> changeClass [
	^ GtWardleyMapUpdateNoteChange
]
