Class {
	#name : #GtWardleyMapAddNoteChangeSpecification,
	#superclass : #GtWardleyMapNotePropertiesChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapAddNoteChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapAddNote'
]

{ #category : #changes }
GtWardleyMapAddNoteChangeSpecification >> changeClass [
	^ GtWardleyMapAddNoteChange
]

{ #category : #changes }
GtWardleyMapAddNoteChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	change execute.
	proposition := GtWardleyMapAddProposition new.
	change newNote addWardleyMapDecoratorModel: proposition
]

{ #category : #private }
GtWardleyMapAddNoteChangeSpecification >> updateNewUidsUsing: aDictionary [
	| newId |
	super updateNewUidsUsing: aDictionary.
	newId := UUID new printString.
	aDictionary at: noteId put: newId.
	noteId := newId
]
