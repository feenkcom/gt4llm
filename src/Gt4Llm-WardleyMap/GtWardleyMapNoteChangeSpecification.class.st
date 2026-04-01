Class {
	#name : #GtWardleyMapNoteChangeSpecification,
	#superclass : #GtWardleyMapChangeSpecification,
	#instVars : [
		'noteId'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #accessing }
GtWardleyMapNoteChangeSpecification >> noteId [
	^ noteId
]

{ #category : #accessing }
GtWardleyMapNoteChangeSpecification >> noteId: anObject [
	noteId := anObject
]

{ #category : #accessing }
GtWardleyMapNoteChangeSpecification >> noteIdDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #noteId;
		  withUUIDFormatCommentWith: 'The id of the note'
]

{ #category : #private }
GtWardleyMapNoteChangeSpecification >> updateNewUidsUsing: aDictionary [
	super updateNewUidsUsing: aDictionary.
	aDictionary at: noteId ifPresent: [ :id | noteId := id ]
]
