Class {
	#name : #GtWardleyMapRemoveNoteChangeSpecification,
	#superclass : #GtWardleyMapNoteChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapRemoveNoteChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapRemoveNote'
]

{ #category : #changes }
GtWardleyMapRemoveNoteChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapRemoveNoteChange onMap: aWardleyMapModel)
		note: (self noteWithId: noteId in: aWardleyMapModel);
		yourself
]

{ #category : #changes }
GtWardleyMapRemoveNoteChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	proposition := GtWardleyMapRemoveProposition new.
	change note addWardleyMapDecoratorModel: proposition
]
