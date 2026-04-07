Class {
	#name : #GtWardleyMapNotePropertiesChangeSpecification,
	#superclass : #GtWardleyMapNoteChangeSpecification,
	#instVars : [
		'color',
		'evolution',
		'label',
		'visibility'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #changes }
GtWardleyMapNotePropertiesChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (self changeClass onMap: aWardleyMapModel)
		color: self color;
		evolution: self evolution;
		id: noteId;
		label: self label;
		visibility: self visibility;
		yourself
]

{ #category : #changes }
GtWardleyMapNotePropertiesChangeSpecification >> changeClass [
	self subclassResponsibility
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> color [
	^ color
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> color: anObject [
	color := anObject
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> colorDescription [
	"<magritteDescription>"
	^ MAColorDescription new
		accessor: #color;
		comment: 'Color of the note'
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> evolution [
	^ evolution
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> evolution: anObject [
	evolution := anObject
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> evolutionDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #evolution;
		comment: 'The positition of the note on the evoluation axis'
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> label [
	^ label
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> labelDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #label;
		comment: 'The displayed label for the note'
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> visibility [
	^ visibility
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> visibility: anObject [
	visibility := anObject
]

{ #category : #accessing }
GtWardleyMapNotePropertiesChangeSpecification >> visibilityDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #visibility;
		comment: 'The positition of the note on the vibility axis'
]
